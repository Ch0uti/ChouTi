//
//  DelayTask.swift
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
    public var task: dispatch_block_t
    
    /**
     Init a Task with task closure
     
     - parameter task: task closure
     
     - returns: a Task
     */
    init(task: dispatch_block_t) {
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
}

/**
 Executes the task on the main queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds
 - parameter task: task to execute after delay
 */
public func delay(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    return delayOnMainQueue(seconds, task: task)
}

/**
 Executes the task on the main queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds
 - parameter task: task to execute after delay
 */
func delayOnMainQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    let task = Task(task: task)
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(delayTime, dispatch_get_main_queue(), {
        if task.canceled == false {
            task.task()
            task._executed = true
        }
    })
    
    return task
}

/**
 Executes the task on a background queue after a set amount of seconds.
 
 - parameter seconds: Delay in seconds
 - parameter task: task to execute after delay
 */
func delayOnBackgroundQueue(seconds: NSTimeInterval, task: dispatch_block_t) -> Task {
    let task = Task(task: task)
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        if task.canceled == false {
            task.task()
            task._executed = true
        }
    })
    
    return task
}
