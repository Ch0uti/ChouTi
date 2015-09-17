//
//  UIView+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//

import UIKit

public extension UIView {
	public func containSubview(view: UIView) -> Bool {
		return subviews.filter({$0 == view}).count > 0
	}
	
	public func removeAllSubviews() {
		for subview in subviews {
			subview.removeFromSuperview()
		}
	}
	
	public func removeAllSubviewsExceptView(view: UIView) {
		for subview in subviews.filter({$0 != view}) {
			subview.removeFromSuperview()
		}
	}
	
	public func removeAllSubviewsExceptViews(views: [UIView]) {
		for subview in subviews.filter({ views.contains($0) }) {
			subview.removeFromSuperview()
		}
	}
}
