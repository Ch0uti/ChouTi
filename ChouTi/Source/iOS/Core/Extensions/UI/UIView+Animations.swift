//
//  UIView+Animations.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-04-13.
//
//

import UIKit

public extension UIView {
	public func animateIf(_ condition: Bool, duration: TimeInterval, animations: @escaping () -> Void) {
		if condition {
			UIView.animate(withDuration: duration, animations: animations)
		} else {
			animations()
		}
	}
	
	public func animateIf(_ condition: Bool, duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animate(withDuration: duration, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
	
	public func animateIf(_ condition: Bool, duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
	
	public func animateIf(_ condition: Bool, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
		if condition {
			UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
		} else {
			animations()
			completion?(false)
		}
	}
}
