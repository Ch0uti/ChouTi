// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

// Example:
//	public class AsyncAddOperation: AsyncOperation {
//		private let lhs: Int
//		private let rhs: Int
//
//		public var result: Int?
//
//		public init(lhs: Int, rhs: Int) {
//			self.lhs = lhs
//			self.rhs = rhs
//
//			super.init()
//		}
//
//		public override func main() {
//			DispatchQueue.global().async {
//				defer {
//					// 🔑 Set this, or the operation will never complete!
//					self.state = .finished
//				}
//
//				// Executing
//				Thread.sleep(forTimeInterval: 2)
//
//				guard !self.isCancelled else {
//					return
//				}
//
//				self.result = self.lhs + self.rhs
//			}
//		}
//
//		public override func cancel() {
//			super.cancel()
//		}
//	}

/// A base class of asynchronous operation.
/// Subclass notes:
/// 	- Overriding `main()`: When this is called, the state is `executing`.
///   	Make sure when the job finishes, call `finish()`
///			Check `isCancelled` during the executing if needed.
///   - Overriding `cancel()`: Call `super.cancel()` first then do the cancellation. No need to call `finish()`.
open class AsyncOperation: Operation {
  /// Allows us to asynchronously track changes of the operation state
  public enum State: String {
    case ready
    case executing
    case finished

    /// This allows the enum to correspond to the `is-*` properties of the `Operation` class.
    /// and signal to them through KVO.
    fileprivate var keyPath: String {
      return "is\(rawValue.capitalized)"
    }

    fileprivate func canTransition(to newState: State) -> Bool {
      switch (self, newState) {
      case (.ready, _):
        return true
      case (.executing, .finished):
        return true
      default:
        return false
      }
    }
  }

  public private(set) var state: State {
    get {
      _stateQueue.sync { _state }
    }
    set {
      /*
       It's important to note that the KVO notifications are NOT called from inside
       the queue. If they were, the app would deadlock, because in the middle of
       calling the `didChangeValue()` method, the observers try to access
       properties like "isReady" or "isFinished". Since those methods also
       access `_state` on the same queue, then we'd be stuck waiting on our queue.
       It's the classic definition of deadlock.
       */
      let oldValue = state
      willChangeValue(forKey: oldValue.keyPath)
      willChangeValue(forKey: newValue.keyPath)

      _stateQueue.sync(flags: .barrier) {
        assert(_state.canTransition(to: newValue), "Performing invalid state transition (\(_state) -> \(newValue)).")
        _state = newValue
      }

      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: newValue.keyPath)
    }
  }

  /// Don't mutate `_state` directly, use `state`.
  private var _state: State = .ready

  /// An internal queue for state access.
  private let _stateQueue = DispatchQueue(label: "com.chouti.async_operation", attributes: .concurrent)
}

// MARK: - Computed

extension AsyncOperation {
  public override var isAsynchronous: Bool { true }

  // 📝 NOTE:
  // - It’s critical to check the base class's `isReady` method.
  // 	Our code isn’t aware of everything that goes on while the scheduler determines whether
  // 	or not it is ready to find a thread for the operation.
  //
  // - When executing, `isReady` should be `true`.
  public override var isReady: Bool { super.isReady && (state == .ready || state == .executing) }

  public override var isExecuting: Bool { state == .executing }
  public override var isFinished: Bool { state == .finished }
}

// MARK: - Core Functions

extension AsyncOperation {
  public override func start() {
    guard !isCancelled else {
      state = .finished
      return
    }

    state = .executing
    main()
  }

  open override func main() {
    fatalError("Subclass should implement `main()`.")
  }

  /// Mark operation finished.
  public func finish() {
    state = .finished
  }
}
