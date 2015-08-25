//
//  UINavigationBar+UI.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-17.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
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
		
		if let subviews = view.subviews as? [UIView] {
			for subview in subviews {
				if let imageView = hairlineImageViewInNavigationBar(subview) {
					return imageView
				}
			}
		}
		return nil
	}
}
