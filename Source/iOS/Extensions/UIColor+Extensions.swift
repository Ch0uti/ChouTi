//
//  UIColor+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-04.
//
//

import UIKit

public extension UIColor {
	/**
	Get Red component from this UIColor
	
	:returns: Red value
	*/
	public func getRedComponent() -> CGFloat {
		var red: CGFloat = 0.0
		self.getRed(&red, green: nil, blue: nil, alpha: nil)
		return red
	}
	
	/**
	Get Green component from this UIColor
	
	:returns: Green value
	*/
	public func getGreenComponent() -> CGFloat {
		var green: CGFloat = 0.0
		self.getRed(nil, green: &green, blue: nil, alpha: nil)
		return green
	}
	
	/**
	Get Blue component from this UIColor
	
	:returns: Blue value
	*/
	public func getBlueComponent() -> CGFloat {
		var blue: CGFloat = 0.0
		self.getRed(nil, green: nil, blue: &blue, alpha: nil)
		return blue
	}
	
	/**
	Get Alpha component from this UIColor
	
	:returns: Alpha value
	*/
	public func getAlphaComponent() -> CGFloat {
		var alpha: CGFloat = 0.0
		self.getRed(nil, green: nil, blue: nil, alpha: &alpha)
		return alpha
	}
	
	/**
	Get (Red, Green, Blue, Alpha) components from this UIColor
	
	:returns: (Red, Green, Blue, Alpha)
	*/
	public func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return (red, green, blue, alpha)
	}
}
