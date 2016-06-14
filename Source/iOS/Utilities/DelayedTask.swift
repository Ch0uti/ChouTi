//
//  DelayedTask.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-02-04.
//
//

import Foundation

/// Cancelable task
public class Task {
    /// Whether this task is canceled
    public var canceled: Bool = false
    
    var _executed: Bool = false
    /// Whether this task has been called to execute
    public var executed: Bool { return _executed }
    
    /// Closure to be executed
    public let task: dispatch_block_t
	
	/// Queue the task will run
    public let queue: dispatch_queue_t
	
	/// Delay seconds
	private let seconds: NSTimeInterval
	
	/**
	Init a Task with delay seconds, queue and task closure
	
	- parameter seconds: delay seconds.
	- parameter queue:   queue to be executed in.
	- parameter task:    task closure
	
	- returns: a dispatched Task
	*/
    init(seconds: NSTimeInterval, queue: dispatch_queue_t, task: dispatch_block_t) {
		self.seconds = seconds
		self.queue = queue
        self.task = task
    }
    
    /**
     Cancel this task
     */
    public func cancel() {
        canceled = true
    }
    
    /**
     Resume this task
     */
    public func resume() {
        canceled = false
    }
	
    /// Next chained task
    var nextTask: Task?

    /**
     Chain a delayed task in main queue to this task.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A Task.
     */
    public func then(seconds: NSTimeInterval = 0.0, task: dispatch_block_t) -> Task {
        return thenOnMainQueue(seconds, task: task)
    }
    
    /**
     Chain a delayed task in main queue to this task.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A Task.
     */
    public func thenOnMainQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        return thenDelayOnQueue(dispatch_get_main_queue(), seconds: seconds, task: task)
    }
    
    /**
     Chain a delayed task in background queue to this task.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A Task.
     */
    public func thenOnBackgroundQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        return thenDelayOnQueue(backgroundQueue, seconds: seconds, task: task)
    }
	
    /**
     Chain a delayed task in queue to this task.
     
     - parameter queue:   Queue for this task to execute.
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A Task.
     */
	private func thenDelayOnQueue(queue: dispatch_queue_t, seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        let task = Task(seconds: seconds, queue: queue, task: task)
        nextTask = task
        return task
	}
}

// MARK: - Public Methods
public extension Task {
    /**
     Executes the task on the main queue after a set amount of seconds.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A delayed Task.
     */
    public class func delay(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        return delayOnMainQueue(seconds, task: task)
    }
    
    /**
     Executes the task on the main queue after a set amount of seconds.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A delayed Task.
     */
    public class func delayOnMainQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        return delayOnQueue(dispatch_get_main_queue(), seconds: seconds, task: task)
    }
    
    /**
     Executes the task on a background queue after a set amount of seconds.
     
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A delayed Task.
     */
    public class func delayOnBackgroundQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        return delayOnQueue(backgroundQueue, seconds: seconds, task: task)
    }
    
    /**
     Executes the task on a queue after a set amount of seconds.
     
     - parameter queue:   A queue
     - parameter seconds: Delay in seconds.
     - parameter task:    Task to execute after delay.
     
     - returns: A delayed Task.
     */
    private class func delayOnQueue(queue: dispatch_queue_t, seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
        let task = Task(seconds: seconds, queue: queue, task: task)
        return dispatch(task)
    }
    
    /**
     Dispatch a Task
     
     - parameter task: Task object to dispatch
     
     - returns: This task
     */
    private class func dispatch(task: Task) -> Task {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * task.seconds))
        dispatch_after(delayTime, task.queue, {
            if task.canceled == false {
                task.task()
                task._executed = true
                
                // dispatch next task if needed
                if let nextTask = task.nextTask {
                    dispatch(nextTask)
                }
            }
        })
        
        return task
    }
}

/**
 Executes the task on the main queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds.
 - parameter task:    Task to execute after delay.
 
 - returns: A delayed Task.
 */
public func delay(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    return Task.delayOnMainQueue(seconds, task: task)
}

/**
 Executes the task on the main queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds.
 - parameter task:    Task to execute after delay.
 
 - returns: A delayed Task.
 */
public func delayOnMainQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    return Task.delayOnQueue(dispatch_get_main_queue(), seconds: seconds, task: task)
}

/**
 Executes the task on a background queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds.
 - parameter task:    Task to execute after delay.
 
 - returns: A delayed Task.
 */
public func delayOnBackgroundQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    return Task.delayOnQueue(backgroundQueue, seconds: seconds, task: task)
}
