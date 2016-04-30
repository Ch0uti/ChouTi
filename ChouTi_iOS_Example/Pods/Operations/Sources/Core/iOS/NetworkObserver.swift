//
//  NetworkObserver.swift
//  Operations
//
//  Created by Daniel Thorpe on 19/07/2015.
//  Copyright © 2015 Daniel Thorpe. All rights reserved.
//

import UIKit

protocol NetworkActivityIndicatorInterface {
    var networkActivityIndicatorVisible: Bool { get set }
}

extension UIApplication: NetworkActivityIndicatorInterface { }

/**
An `OperationObserverType` which can be used to manage the network
activity indicator in iOS. Note that this is not an observer of
when the network is available. See `ReachableOperation`.
*/
public class NetworkObserver: OperationDidStartObserver, OperationDidFinishObserver {

    let networkActivityIndicator: NetworkActivityIndicatorInterface

    /// Initializer takes no parameters.
    public convenience init() {
        self.init(indicator: UIApplication.sharedApplication())
    }

    init(indicator: NetworkActivityIndicatorInterface) {
        networkActivityIndicator = indicator
    }

    /// Conforms to `OperationObserver`, will start the network activity indicator.
    public func didStartOperation(operation: Operation) {
        dispatch_async(Queue.Main.queue) {
            NetworkIndicatorController.sharedInstance.networkActivityIndicator = self.networkActivityIndicator
            NetworkIndicatorController.sharedInstance.networkActivityDidStart()
        }
    }

    /// Conforms to `OperationObserver`, will stop the network activity indicator.
    public func didFinishOperation(operation: Operation, errors: [ErrorType]) {
        dispatch_async(Queue.Main.queue) {
            NetworkIndicatorController.sharedInstance.networkActivityIndicator = self.networkActivityIndicator
            NetworkIndicatorController.sharedInstance.networkActivityDidEnd()
        }
    }
}

private class NetworkIndicatorController {

    static let sharedInstance = NetworkIndicatorController()

    private var activityCount = 0
    private var visibilityTimer: Timer?

    var networkActivityIndicator: NetworkActivityIndicatorInterface = UIApplication.sharedApplication()

    private init() {
        // Prevents use outside of the shared instance.
    }

    private func updateIndicatorVisibility() {
        if activityCount > 0 {
            networkIndicatorShouldShow(true)
        }
        else {
            visibilityTimer = Timer(interval: 1.0) {
                self.networkIndicatorShouldShow(false)
            }
        }
    }

    private func networkIndicatorShouldShow(shouldShow: Bool) {
        visibilityTimer?.cancel()
        visibilityTimer = .None
        networkActivityIndicator.networkActivityIndicatorVisible = shouldShow
    }

    // Public API

    func networkActivityDidStart() {
        assert(NSThread.isMainThread(), "Altering network activity indicator state can only be done on the main thread.")
        activityCount += 1
        updateIndicatorVisibility()
    }

    func networkActivityDidEnd() {
        assert(NSThread.isMainThread(), "Altering network activity indicator state can only be done on the main thread.")
        activityCount -= 1
        updateIndicatorVisibility()
    }
}

private struct Timer {

    private var isCancelled = false

    init(interval: NSTimeInterval, handler: dispatch_block_t) {
        let after = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
        dispatch_after(after, Queue.Main.queue) {
            if self.isCancelled != true {
                handler()
            }
        }
    }

    mutating func cancel() {
        isCancelled = true
    }
}
