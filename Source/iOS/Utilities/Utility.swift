//
//  Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-25.
//

import Foundation

/**
Executes the task on the main queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter task: task to execute after delay
*/
public func delay(seconds: NSTimeInterval, task: dispatch_block_t) {
	delayOnMainQueue(seconds, task: task)
}

/**
Executes the task on the main queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter task: task to execute after delay
*/
func delayOnMainQueue(seconds: NSTimeInterval, task: dispatch_block_t) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
	dispatch_after(delayTime, dispatch_get_main_queue(), task)
}

/**
Executes the task on a background queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter task: task to execute after delay
*/
func delayOnBackgroundQueue(seconds: NSTimeInterval, task: dispatch_block_t) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
	dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), task)
}
