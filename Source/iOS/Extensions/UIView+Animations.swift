//
//  UIView+Animations.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-04-13.
//
//

import UIKit

public extension UIView {
	public func animateIf(condition: Bool, duration: NSTimeInterval, animations: () -> Void) {
		if condition {
			UIView.animateWithDuration(duration, animations: animations)
		} else {
			animations()
		}
	}
	
	public func animateIf(condition: Bool, duration: NSTimeInterval, animations: () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animateWithDuration(duration, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
	
	public func animateIf(condition: Bool, duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
	
	public func animateIf(condition: Bool, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
}
