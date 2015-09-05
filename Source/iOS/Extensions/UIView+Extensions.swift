//
//  UIView+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-04.
//
//

import UIKit

public extension UIView {
	public func containSubview(view: UIView) -> Bool {
		return subviews.filter({$0 as? UIView == view}).count > 0
	}
	
	public func removeAllSubviews() {
		for subview in subviews {
			(subview as? UIView)?.removeFromSuperview()
		}
	}
	
	public func removeAllSubviewsExceptView(view: UIView) {
		for subview in subviews.filter({$0 as? UIView != view}) {
			(subview as? UIView)?.removeFromSuperview()
		}
	}
	
	public func removeAllSubviewsExceptViews(views: [UIView]) {
		for subview in subviews.filter({ contains(views, ($0 as! UIView)) }) {
			(subview as? UIView)?.removeFromSuperview()
		}
	}
}
