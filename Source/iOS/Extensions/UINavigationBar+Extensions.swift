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


// MARK: - Customization of navigation bar title
public extension UINavigationBar {
	var titleTextColor: UIColor? {
		set {
			if let titleTextColor = newValue {
				if titleTextAttributes != nil {
					titleTextAttributes?[NSForegroundColorAttributeName] = titleTextColor
				} else {
					titleTextAttributes = [NSForegroundColorAttributeName: titleTextColor]
				}
			} else {
				titleTextAttributes?.removeValueForKey(NSForegroundColorAttributeName)
			}
		}

		get {
			if let titleTextAttributes = titleTextAttributes {
				return titleTextAttributes[NSForegroundColorAttributeName] as? UIColor
			} else {
				return nil
			}
		}
	}
	
	var titleTextFont: UIFont? {
		set {
			if let titleTextFont = newValue {
				if titleTextAttributes != nil {
					titleTextAttributes?[NSFontAttributeName] = titleTextFont
				} else {
					titleTextAttributes = [NSFontAttributeName: titleTextFont]
				}
			} else {
				titleTextAttributes?.removeValueForKey(NSFontAttributeName)
			}
		}
		
		get {
			if let titleTextAttributes = titleTextAttributes {
				return titleTextAttributes[NSFontAttributeName] as? UIFont
			} else {
				return nil
			}
		}
	}
}


// MARK: - Transparent
public extension UINavigationBar {
    public func setToTransparent() {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        shadowImage = UIImage()
        translucent = true
    }
}
