//
//  UINavigationBar+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-17.
//

import UIKit

public extension UINavigationBar {
	public func hideBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView?.hidden = true
	}
	
	public func showBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView?.hidden = false
	}
	
	private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
		if let view = view as? UIImageView where view.bounds.height <= 1.0 {
			return view
		}
		
		for subview in view.subviews {
			if let imageView = hairlineImageViewInNavigationBar(subview) {
				return imageView
			}
		}
		
		return nil
	}
}
