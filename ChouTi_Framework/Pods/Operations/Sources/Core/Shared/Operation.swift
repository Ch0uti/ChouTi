//
//  Operation.swift
//  YapDB
//
//  Created by Daniel Thorpe on 25/06/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import Foundation

/**
Abstract base Operation class which subclasses `NSOperation`.

Operation builds on `NSOperation` in a few simple ways.

1. For an instance to become `.Ready`, all of its attached
`OperationCondition`s must be satisfied.

2. It is possible to attach `OperationObserver`s to an instance, 
to be notified of lifecycle events in the operation.

*/
public class Operation: NSOperation {

    private enum State: Int, Comparable {

        // The initial state
        case Initialized

        // Ready to begin evaluating conditions
        case Pending

        // Is evaluating conditions
        case EvaluatingConditions

        // Conditions have been satisfied, ready to execute
        case Ready

        // It is executing
        case Executing

        // Execution has completed, but not yet notified queue
        case Finishing

        // The operation has finished.
        case Finished

        func canTransitionToState(other: State, whenCancelled cancelled: Bool) -> Bool {
            switch (self, other) {
            case (.Initialized, .Pending),
                (.Pending, .EvaluatingConditions),
                (.EvaluatingConditions, .Ready),
                (.Ready, .Executing),
                (.Ready, .Finishing),
                (.Executing, .Finishing),
                (.Finishing, .Finished):
                return true

            case (.Pending, .Ready):
                // Note that PSOperations only allows this transition when the operation is
                // cancelled. However, in the case where there are no conditions to evaluate,
                // Operation immediately becomes .Ready - otherwise there exists a race
                // condition because the evaluator executes its completion immediately.
                return true

            case (.Pending, .Finishing) where cancelled:
                // When an operation is cancelled it can go from pending direct to finishing.
                return true

            default:
                return false
            }
        }
    }

    // use the KVO mechanism to indicate that changes to "state" affect other properties as well
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return ["State", "Cancelled"]
    }

    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return ["State"]
    }

    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return ["State"]
    }

    class func keyPathsForValuesAffectingIsCancelled() -> Set<NSObject> {
        return ["Cancelled"]
    }

    private let stateLock = NSLock()
    private let readyLock = NSRecursiveLock()

    private lazy var _log: LoggerType = Logger()
    private var _state = State.Initialized
    private var _internalErrors = [ErrorType]()

    private(set) var conditions = [OperationCondition]()
    private(set) var observers = [OperationObserverType]()

    private var state: State {
        get {
            return stateLock.withCriticalScope { _state }
        }
        set (newState) {
            willChangeValueForKey("State")
            stateLock.withCriticalScope {
                assert(_state.canTransitionToState(newState, whenCancelled: cancelled), "Attempting to perform illegal cyclic state transition, \(_state) -> \(newState).")
                log.verbose("\(_state) -> \(newState)")
                _state = newState
            }
            didChangeValueForKey("State")
        }
    }

    private var _cancelled = false {
        willSet {
            willChangeValueForKey("Cancelled")
        }
        didSet {
            didChangeValueForKey("Cancelled")

            if _cancelled && !oldValue {
                didCancelObservers.forEach { $0.operationDidCancel(self) }
            }
        }
    }

    /// Access the internal errors collected by the Operation
    public var errors: [ErrorType] {
        return _internalErrors
    }

    /// Boolean flag to indicate that the Operation failed due to errors.
    public var failed: Bool {
        return errors.count > 0
    }

    /// Boolean indicator of the readyness of the Operation
    public override var ready: Bool {
        return readyLock.withCriticalScope {
            switch state {
            case .Initialized:
                // If the operation is cancelled, isReady should return true
                return cancelled

            case .Pending:
                // If the operation is cancelled, isReady should return true
                if cancelled {
                    state = .Ready
                    return true
                }

                if super.ready {
                    if conditions.count == 0 {
                        state = .Ready
                        return true
                    }
                    evaluateConditions()
                }

                // Until conditions have been evaluated, we're not ready
                return false

            case .Ready:
                return super.ready || cancelled

            default:
                return false
            }
        }
    }

    /**
     Modifies the quality of service of the underlying operation.

     - requires: self must not have started yet. i.e. either hasn't been added
     to a queue, or is waiting on dependencies.

     - returns: a Bool indicating whether or not the quality of service is .UserInitiated
    */
    public var userInitiated: Bool {
        get {
            return qualityOfService == .UserInitiated
        }
        set {
            precondition(state < .Executing, "Cannot modify userInitiated after execution has begun.")
            qualityOfService = newValue ? .UserInitiated : .Default
        }
    }

    /// Boolean indicator for whether the Operation is currently executing or not
    public override var executing: Bool {
        return state == .Executing
    }

    /// Boolean indicator for whether the Operation has finished or not
    public override var finished: Bool {
        return state == .Finished
    }

    /// Boolean indicator for whether the Operation has cancelled or not
    public override var cancelled: Bool {
        return _cancelled
    }

    /**
     # Access the logger for this Operation
     The `log` property can be used as the interface to access the logger.
     e.g. to output a message with `LogSeverity.Info` from inside
     the `Operation`, do this:
    
    ```swift
    log.info("This is my message")
    ```
    
     To adjust the instance severity of the LoggerType for the
     `Operation`, access it via this property too:
    
    ```swift
    log.severity = .Verbose
    ```
    
     The logger is a very simple type, and all it does beyond 
     manage the enabled status and severity is send the String to
     a block on a dedicated serial queue. Therefore to provide custom
     logging, set the `logger` property:
     
     ```swift
     log.logger = { message in sendMessageToAnalytics(message) }
     ```
     
     By default, the Logger's logger block is the same as the global
     LogManager. Therefore to use a custom logger for all Operations:
     
     ```swift
     LogManager.logger = { message in sendMessageToAnalytics(message) }
     ```

    */
    public var log: LoggerType {
        get {
            _log.operationName = operationName
            return _log
        }
        set {
            _log = newValue
        }
    }

    /**
    Indicates that the Operation can now begin to evaluate readiness conditions,
    if appropriate.
    */
    func willEnqueue() {
        state = .Pending
    }

    private func evaluateConditions() {
        assert(state == .Pending, "\(__FUNCTION__) was called out of order.")
        assert(cancelled == false, "\(__FUNCTION__) was called on cancelled operation: \(operationName).")
        state = .EvaluatingConditions
        evaluateOperationConditions(conditions, operation: self) { errors in
            self._internalErrors.appendContentsOf(errors)
            self.state = .Ready
        }
    }

    // MARK: - Conditions

    /**
     Add a condition to the to the operation, can only be done prior to the operation starting.

     - requires: self must not have started yet. i.e. either hasn't been added
     to a queue, or is waiting on dependencies.
     - parameter condition: type conforming to protocol `OperationCondition`.
    */
    public func addCondition(condition: OperationCondition) {
        assert(state < .EvaluatingConditions, "Cannot modify conditions after operations has begun evaluating conditions, current state: \(state).")
        conditions.append(condition)
    }

    // MARK: - Observers

    var didStartObservers: [OperationDidStartObserver] {
        return observers.flatMap { $0 as? OperationDidStartObserver }
    }

    var didCancelObservers: [OperationDidCancelObserver] {
        return observers.flatMap { $0 as? OperationDidCancelObserver }
    }

    var didProduceOperationObservers: [OperationDidProduceOperationObserver] {
        return observers.flatMap { $0 as? OperationDidProduceOperationObserver }
    }

    var didFinishObservers: [OperationDidFinishObserver] {
        return observers.flatMap { $0 as? OperationDidFinishObserver }
    }

    /**
     Add an observer to the to the operation, can only be done
     prior to the operation starting.

     - requires: self must not have started yet. i.e. either hasn't been added
     to a queue, or is waiting on dependencies.
     - parameter observer: type conforming to protocol `OperationObserverType`.
    */
    public func addObserver(observer: OperationObserverType) {
        switch observer {
        case is OperationDidProduceOperationObserver:
            assert(state < .Executing, "Cannot add OperationDidProduceOperationObserver if operation has entered .Executing state, current state: \(state).")
        case is OperationDidFinishObserver:
            assert(state < .Finishing, "Cannot add OperationDidFinishObserver if operation has entered .Finishing state, current state: \(state).")
        default:
            assert(state < .Ready, "Cannot modify observers after operations has been ready, current state: \(state).")
        }
        observers.append(observer)
    }

    // MARK: - Dependencies

    private func createDidFinishDependenciesOperation() -> NSOperation {
        assert(waitForDependenciesOperation == nil, "Should only ever create the finishing dependency once.")
        let __op = NSBlockOperation { }
        super.addDependency(__op)
        waitForDependenciesOperation = __op
        return __op
    }

    internal var waitForDependenciesOperation: NSOperation? = .None

    internal func addConditionDependency(operation: NSOperation) {
        precondition(state <= .Executing, "Dependencies cannot be modified after execution has begun, current state: \(state).")
        if let waiter = waitForDependenciesOperation {
            operation.addDependency(waiter)
        }
        super.addDependency(operation)
    }

    /// Public override to get the dependencies
    public override final var dependencies: [NSOperation] {
        get {
            var _dependencies = super.dependencies
            guard let
                waiter = waitForDependenciesOperation,
                index = _dependencies.indexOf(waiter) else {
                return _dependencies
            }

            _dependencies.removeAtIndex(index)
            _dependencies.appendContentsOf(waiter.dependencies)

            return _dependencies
        }
    }

    /**
     Add another `NSOperation` as a dependency. It is a programmatic error to call
     this method after the receiver has already started executing. Therefore, best 
     practice is to add dependencies before adding them to operation queues.
    
     - requires: self must not have started yet. i.e. either hasn't been added
     to a queue, or is waiting on dependencies.
     - parameter operation: a `NSOperation` instance.
    */
    public override final func addDependency(operation: NSOperation) {
        precondition(state <= .Executing, "Dependencies cannot be modified after execution has begun, current state: \(state).")
        (waitForDependenciesOperation ?? createDidFinishDependenciesOperation()).addDependency(operation)
    }

    /**
     Remove another `NSOperation` as a dependency. It is a programmatic error to call
     this method after the receiver has already started executing. Therefore, best 
     practice is to manage dependencies before adding them to operation
     queues.

     - requires: self must not have started yet. i.e. either hasn't been added
     to a queue, or is waiting on dependencies.
     - parameter operation: a `NSOperation` instance.
     */
    public override final func removeDependency(operation: NSOperation) {
        precondition(state <= .Executing, "Dependencies cannot be modified after execution has begun, current state: \(state).")
        guard let waiter = waitForDependenciesOperation else {
            return
        }
        waiter.removeDependency(operation)
        if waiter.dependencies.count == 0 {
            super.removeDependency(waiter)
            waitForDependenciesOperation = nil
        }
    }

    // MARK: - Execution and Cancellation

    /// Starts the operation, correctly managing the cancelled state. Cannot be over-ridden
    public override final func start() {
        // Don't call super.start

        if !cancelled {
            main()
        }
        else {
            // If the operation has been cancelled, we still need to enter the finished state
            finish()
        }
    }

    /// Triggers execution of the operation's task, correctly managing errors and the cancelled state. Cannot be over-ridden
    public override final func main() {
        assert(state == .Ready, "This operation must be performed on an operation queue, current state: \(state).")

        if _internalErrors.isEmpty && !cancelled {
            state = .Executing
            log.verbose("Will Execute")
            didStartObservers.forEach { $0.operationDidStart(self) }
            execute()
        }
        else {
            finish()
        }
    }

    /**
    Subclasses should override this method to perform their specialized task.
    They must call a finish methods in order to complete.
    */
    public func execute() {
        print("\(self.dynamicType) must override `execute()`.", terminator: "")
        finish()
    }

    /**
    Cancel the operation with an error.
    
    - parameter error: an optional `ErrorType`.
    */
    public func cancelWithError(error: ErrorType? = .None) {
        cancelWithErrors(error.map { [$0] } ?? [])
    }

    /**
     Cancel the operation with multiple errors.

     - parameter errors: an `[ErrorType]` defaults to empty array.
     */
    public func cancelWithErrors(errors: [ErrorType] = []) {
        if !errors.isEmpty {
            log.verbose("Did cancel with errors: \(errors).")
        }
        _internalErrors += errors
        cancel()
    }


    public override func cancel() {
        if !finished {

            log.verbose("Did cancel.")

            _cancelled = true

            if state > .Ready {
                super.cancel()
                finish()
            }
        }
    }

    /**
    Produce another operation on the same queue that this instance is on.

    - parameter operation: a `NSOperation` instance.
    */
    public final func produceOperation(operation: NSOperation) {
        precondition(state > .Initialized, "Cannot produce operation while not being scheduled on a queue.")
        log.verbose("Did produce \(operation.operationName)")
        didProduceOperationObservers.forEach { $0.operation(self, didProduceOperation: operation) }
    }
    
    // MARK: Finishing

    /**
    A private property to ensure we only notify the observers once that the
    operation has finished.
    */
    private var hasFinishedAlready = false

    /**
    Finish method which must be called eventually after an operation has
    begun executing, unless it is cancelled.

    - parameter errors: an array of `ErrorType`, which defaults to empty.
    */
    final public func finish(receivedErrors: [ErrorType] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .Finishing

            _internalErrors.appendContentsOf(receivedErrors)
            finished(_internalErrors)

            if errors.isEmpty {
                log.verbose("Did finish with no errors.")
            }
            else {
                log.verbose("Did finish with errors: \(_internalErrors).")
            }

            didFinishObservers.forEach { $0.operationDidFinish(self, errors: self._internalErrors) }

            state = .Finished
        }
    }
    
    /// Convenience method to simplify finishing when there is only one error.
    final public func finish(receivedError: ErrorType?) {
        finish(receivedError.map { [$0]} ?? [])
    }

    /**
    Subclasses may override `finished(_:)` if they wish to react to the operation
    finishing with errors.
    
    - parameter errors: an array of `ErrorType`.
    */
    public func finished(errors: [ErrorType]) {
        // No op.
    }

    /**
    Public override which deliberately crashes your app, as usage is considered an antipattern

    To promote best practices, where waiting is never the correct thing to do,
    we will crash the app if this is called. Instead use discrete operations and
    dependencies, or groups, or semaphores or even NSLocking.
    
    */
    public override func waitUntilFinished() {
        fatalError("Waiting on operations is an anti-pattern. Remove this ONLY if you're absolutely sure there is No Other Way™. Post a question in https://github.com/danthorpe/Operations if you are unsure.")
    }
}

private func <(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

private func ==(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

/**
A common error type for Operations. Primarily used to indicate error when
an Operation's conditions fail.
*/
public enum OperationError: ErrorType, Equatable {

    /// Indicates that a condition of the Operation failed.
    case ConditionFailed

    /// Indicates that the operation timed out.
    case OperationTimedOut(NSTimeInterval)
}

/// OperationError is Equatable.
public func ==(a: OperationError, b: OperationError) -> Bool {
    switch (a, b) {
    case (.ConditionFailed, .ConditionFailed):
        return true
    case let (.OperationTimedOut(aTimeout), .OperationTimedOut(bTimeout)):
        return aTimeout == bTimeout
    default:
        return false
    }
}

extension NSOperation {

    /** 
    Chain completion blocks.
    
    - parameter block: a Void -> Void block
    */
    public func addCompletionBlock(block: Void -> Void) {
        if let existing = completionBlock {
            completionBlock = {
                existing()
                block()
            }
        }
        else {
            completionBlock = block
        }
    }
    
    /** 
    Add multiple depdendencies to the operation. Will add each 
    dependency in turn.

    - parameter dependencies: and array of `NSOperation` instances.
    */
    public func addDependencies(dependencies: [NSOperation]) {
        dependencies.forEach(addDependency)
    }
}

extension NSLock {
    func withCriticalScope<T>(@noescape block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

extension NSRecursiveLock {
    func withCriticalScope<T>(@noescape block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}


