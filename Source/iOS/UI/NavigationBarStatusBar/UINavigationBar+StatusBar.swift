//
//  UINavigationBar+StatusBar.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-15.
//
//

import UIKit

// TODO: Auto dismiss enum, associated with displayingDuration, dismissingAnimationDuration
// 

public extension UINavigationBar {
	private struct StatusBarKey {
		static var Key = "StatusBarKey"
	}
	
	var statusBar: NavigationBarStatusBar {
		get {
			if let bar = getAssociatedObject(forKeyPointer: &StatusBarKey.Key) as? NavigationBarStatusBar {
				return bar
			} else {
				let statusBar = NavigationBarStatusBar()
				self.statusBar = statusBar
				return statusBar
			}
		}
		
		set {
			setAssociatedObejct(newValue, forKeyPointer: &StatusBarKey.Key)
		}
	}
	
	private struct HiddenConstraintKey {
		static var Key = "HiddenConstraintKey"
	}
	
	var hiddenConstraint: NSLayoutConstraint {
		get {
			if let constraint = getAssociatedObject(forKeyPointer: &HiddenConstraintKey.Key) as? NSLayoutConstraint {
				return constraint
			} else {
				let constraint = NSLayoutConstraint(item: statusBar, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
				setAssociatedObejct(constraint, forKeyPointer: &HiddenConstraintKey.Key)
				return constraint
			}
		}
	}
	
	private struct ShownConstraintKey {
		static var Key = "ShownConstraintKey"
	}
	
	var shownConstraint: NSLayoutConstraint {
		get {
			if let constraint = getAssociatedObject(forKeyPointer: &ShownConstraintKey.Key) as? NSLayoutConstraint {
				return constraint
			} else {
				let constraint = NSLayoutConstraint(item: statusBar, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
				setAssociatedObejct(constraint, forKeyPointer: &ShownConstraintKey.Key)
				return constraint
			}
		}
	}
	
	var isShowingStatusBar: Bool {
		guard let superview = superview else {
			NSLog("Error: superview of \(self) is nil")
			return false
		}
		
		return superview.containSubview(statusBar)
	}
	
	func clean() {
		clearAssociatedObject(forKeyPointer: &StatusBarKey.Key)
		clearAssociatedObject(forKeyPointer: &ShownConstraintKey.Key)
		clearAssociatedObject(forKeyPointer: &HiddenConstraintKey.Key)
	}
}

public extension UINavigationBar {
	public func showStatusBarWithText(text: String, animated: Bool, animationDuration: NSTimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) -> NavigationBarStatusBar {
		return showStatusBarWithText(text, animated: animated, animationDuration: animationDuration, completion: completion, autoDismiss: false, displayingDuration: 0.0, dismissCompletion: nil)
	}
	
	public func showStatusBarWithText(text: String, animated: Bool, animationDuration: NSTimeInterval = 0.3, completion: ((Bool) -> Void)? = nil, autoDismiss: Bool, displayingDuration: NSTimeInterval, dismissCompletion: ((Bool) -> Void)? = nil) -> NavigationBarStatusBar {
		if autoDismiss {
			delay(displayingDuration) {
				self.dismissStatusBar(true)
			}
		}
		
		if isShowingStatusBar {
			completion?(false)
			return statusBar
		}
		
		guard let superview = superview else {
			NSLog("Error: superview of \(self) is nil")
			completion?(false)
			return NavigationBarStatusBar()
		}

		statusBar.translatesAutoresizingMaskIntoConstraints = false
		superview.insertSubview(statusBar, belowSubview: self)
		
		statusBar.titleLabel.text = text
		
		setupInitialConstraints()
		superview.layoutIfNeeded()
		
		hiddenConstraint.active = false
		shownConstraint.active = true
		
		if animated {
			UIView.animateWithDuration(animationDuration, animations: { () -> Void in
				superview.layoutIfNeeded()
				}) { (finished) -> Void in
					completion?(finished)
			}
		} else {
			superview.layoutIfNeeded()
			completion?(true)
		}
		
		return statusBar
	}
	
	private func setupInitialConstraints() {
		shownConstraint.active = false
		
		statusBar.height = 44
		var constraints = [NSLayoutConstraint]()
		
		constraints += [NSLayoutConstraint(item: statusBar, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)]
		constraints += [NSLayoutConstraint(item: statusBar, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)]
		constraints += [hiddenConstraint]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	public func dismissStatusBar(animated: Bool, animationDuration: NSTimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		if isShowingStatusBar == false {
			completion?(false)
			return
		}
		
		guard let superview = superview else {
			NSLog("Error: superview of \(self) is nil")
			completion?(false)
			return
		}
		
		shownConstraint.active = false
		hiddenConstraint.active = true
		
		if animated {
			UIView.animateWithDuration(animationDuration, animations: { () -> Void in
				superview.layoutIfNeeded()
				}) { (finished) -> Void in
					self.statusBar.removeFromSuperview()
					self.clean()
					completion?(finished)
			}
		} else {
			superview.layoutIfNeeded()
			self.statusBar.removeFromSuperview()
			self.clean()
			completion?(true)
		}
	}
}
