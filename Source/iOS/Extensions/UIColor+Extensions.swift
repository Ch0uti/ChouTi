//
//  UIColor+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
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



public extension UIColor {
	public class func random(randomAlpha: Bool = false) -> UIColor {
		let randomRed = CGFloat.random()
		let randomGreen = CGFloat.random()
		let randomBlue = CGFloat.random()
		let alpha = randomAlpha ? CGFloat.random() : 1.0
		return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
	}
}

public extension UIColor {
	/**
	Get color between two colors, with percentage
	
	- parameter minColor: color on one end
	- parameter maxColor: color on the other end
	- parameter percent:  percentage from minColor
	
	- returns: <#return value description#>
	*/
	public class func colorBetweenMinColor(minColor: UIColor, maxColor: UIColor, percent: CGFloat) -> UIColor {
		let (leftR, leftG, leftB, leftA) = minColor.getRGBAComponents()
		let (rightR, rightG, rightB, rightA) = maxColor.getRGBAComponents()
		
		let newR = leftR.toNumber(rightR, withPercent: percent)
		let newG = leftG.toNumber(rightG, withPercent: percent)
		let newB = leftB.toNumber(rightB, withPercent: percent)
		let newA = leftA.toNumber(rightA, withPercent: percent)
		
		return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
	}
}
