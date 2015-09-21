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
