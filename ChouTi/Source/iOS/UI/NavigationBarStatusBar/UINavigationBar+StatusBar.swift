//
//  UINavigationBar+StatusBar.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-01-15.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

// TODO: Auto dismiss enum, associated with displayingDuration, dismissingAnimationDuration
// 

public extension UINavigationBar {
	private enum StatusBarKey {
		static var Key = "StatusBarKey"
	}

	public var statusBar: NavigationBarStatusBar {
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

	private enum HiddenConstraintKey {
		static var Key = "HiddenConstraintKey"
	}

	var hiddenConstraint: NSLayoutConstraint {
        if let constraint = getAssociatedObject(forKeyPointer: &HiddenConstraintKey.Key) as? NSLayoutConstraint {
            return constraint
        } else {
            let constraint = NSLayoutConstraint(item: statusBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            setAssociatedObejct(constraint, forKeyPointer: &HiddenConstraintKey.Key)
            return constraint
        }
	}

	private enum ShownConstraintKey {
		static var Key = "ShownConstraintKey"
	}

	var shownConstraint: NSLayoutConstraint {
        if let constraint = getAssociatedObject(forKeyPointer: &ShownConstraintKey.Key) as? NSLayoutConstraint {
            return constraint
        } else {
            let constraint = NSLayoutConstraint(item: statusBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            setAssociatedObejct(constraint, forKeyPointer: &ShownConstraintKey.Key)
            return constraint
        }
	}

	public var isShowingStatusBar: Bool {
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
	public func showStatusBarWithText(_ text: String, animated: Bool, animationDuration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) -> NavigationBarStatusBar {
		return showStatusBarWithText(text, animated: animated, animationDuration: animationDuration, completion: completion, autoDismiss: false, displayingDuration: 0.0, dismissCompletion: nil)
	}

	public func showStatusBarWithText(_ text: String, animated: Bool, animationDuration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil, autoDismiss: Bool, displayingDuration: TimeInterval, dismissCompletion: ((Bool) -> Void)? = nil) -> NavigationBarStatusBar {
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

		hiddenConstraint.isActive = false
		shownConstraint.isActive = true

		if animated {
			UIView.animate(withDuration: animationDuration, animations: { () -> Void in
				superview.layoutIfNeeded()
				}, completion: { finished -> Void in
					completion?(finished)
			})
		} else {
			superview.layoutIfNeeded()
			completion?(true)
		}

		return statusBar
	}

	private func setupInitialConstraints() {
		shownConstraint.isActive = false

		statusBar.height = 44
		var constraints = [NSLayoutConstraint]()

		constraints += [NSLayoutConstraint(item: statusBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)]
		constraints += [NSLayoutConstraint(item: statusBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)]
		constraints += [hiddenConstraint]

		NSLayoutConstraint.activate(constraints)
	}

	public func dismissStatusBar(_ animated: Bool, animationDuration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		if isShowingStatusBar == false {
			completion?(false)
			return
		}

		guard let superview = superview else {
			NSLog("Error: superview of \(self) is nil")
			completion?(false)
			return
		}

		shownConstraint.isActive = false
		hiddenConstraint.isActive = true

		if animated {
			UIView.animate(withDuration: animationDuration, animations: { () -> Void in
				superview.layoutIfNeeded()
				}, completion: { finished -> Void in
					self.statusBar.removeFromSuperview()
					self.clean()
					completion?(finished)
			})
		} else {
			superview.layoutIfNeeded()
			self.statusBar.removeFromSuperview()
			self.clean()
			completion?(true)
		}
	}
}
