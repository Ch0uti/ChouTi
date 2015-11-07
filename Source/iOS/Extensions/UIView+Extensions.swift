//
//  UIView+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//

import UIKit

public extension UIView {
	public func containSubview(view: UIView) -> Bool {
		if #available(iOS 9.0, *) {
			return subviews.contains(view)
		} else {
			return subviews.filter({$0 == view}).count > 0
		}
	}
	
	public func removeAllSubviews() {
		if #available(iOS 9.0, *) {
			subviews.forEach{ $0.removeFromSuperview() }
		} else {
			for subview in subviews {
				subview.removeFromSuperview()
			}
		}
	}
	
	public func removeAllSubviewsExceptView(view: UIView) {
		if #available(iOS 9.0, *) {
			subviews.filter({$0 != view}).forEach { $0.removeFromSuperview() }
		} else {
			for subview in subviews.filter({$0 != view}) {
				subview.removeFromSuperview()
			}
		}
	}
	
	public func removeAllSubviewsExceptViews(views: [UIView]) {
		if #available(iOS 9.0, *) {
			subviews.filter({ views.contains($0) }).forEach { $0.removeFromSuperview() }
		} else {
			for subview in subviews.filter({ views.contains($0) }) {
				subview.removeFromSuperview()
			}
		}
	}
}

public extension UIView {
	public func frameRectInView(view: UIView?) -> CGRect {
		return self.convertRect(self.bounds, toView: view)
	}
}

// MARK: - Auto Layout
public extension UIView {
	
	public func fullSizeInSuperview() {
		guard let superview = self.superview else {
			fatalError("superview is nil")
		}
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if #available(iOS 9.0, *) {
		    self.topAnchor.constraintEqualToAnchor(superview.topAnchor).active = true
			self.leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor).active = true
			self.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor).active = true
			self.trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor).active = true
		} else {
			NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
		}
	}
	
	public func fullSizeMarginInSuperview() {
		guard let superview = self.superview else {
			fatalError("superview is nil")
		}
		
		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint(item: self, attribute: .TopMargin, relatedBy: .Equal, toItem: superview, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
		NSLayoutConstraint(item: self, attribute: .LeadingMargin, relatedBy: .Equal, toItem: superview, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
		NSLayoutConstraint(item: self, attribute: .BottomMargin, relatedBy: .Equal, toItem: superview, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true
		NSLayoutConstraint(item: self, attribute: .TrailingMargin, relatedBy: .Equal, toItem: superview, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
	}
	
	public func centerInSuperview() {
		guard let superview = self.superview else {
			fatalError("superview is nil")
		}
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if #available(iOS 9.0, *) {
			self.centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor).active = true
			self.centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor).active = true
		} else {
			NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
		}
	}
}

public extension UIView {
	public var isVisible: Bool { return (window != nil) }
}

public extension UIView {
	public func setHidden(hidden: Bool, animated: Bool = false, duration: NSTimeInterval = 0.25, completion: ((Bool) -> ())? = nil) {
		if !animated {
			alpha = hidden ? 0.0 : 1.0
			self.hidden = hidden
			completion?(true)
		} else {
			// If to visible, set hidden to false first, then animate alpha
			if !hidden {
				self.hidden = hidden
			}
			
			UIView.animateWithDuration(duration, animations: {
				self.alpha = hidden ? 0.0 : 1.0
				}, completion: { (finished) -> Void in
					self.hidden = hidden
					completion?(finished)
			})
		}
	}
}

