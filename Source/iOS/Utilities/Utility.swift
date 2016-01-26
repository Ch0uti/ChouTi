//
//  Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-25.
//

import Foundation

/**
Executes the closure on the main queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter closure: Code to execute after delay
*/
public func delay(seconds: Double, closure: () -> ()) {
	delayOnMainQueue(seconds, closure: closure)
}

/**
Executes the closure on the main queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter closure: Code to execute after delay
*/
func delayOnMainQueue(seconds: Double, closure: () -> ()) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
	dispatch_after(delayTime, dispatch_get_main_queue(), closure)
}

/**
Executes the closure on a background queue after a set amount of seconds.

- parameter seconds: Delay in seconds
- parameter closure: Code to execute after delay
*/
func delayOnBackgroundQueue(seconds: Double, closure: () -> ()) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
	dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}
