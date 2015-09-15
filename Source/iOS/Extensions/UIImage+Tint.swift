//
//  UIImage+Tint.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-02.
//

import UIKit

public extension UIImage {
	/**
	Create a gradient color tinted image from top to bottom
	
	:param: colors Gradient colors, from top to bottom.
	
	:returns: A tinted image
	*/
	public func tintedVerticallyWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode = kCGBlendModeNormal) -> UIImage {
		return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPointMake(0.5, 0), endPoint: CGPointMake(0.5, 1))
	}
	
	/**
	Create a gradient color tinted image from left to right
	
	:param: colors Gradient colors, from left to right.
	
	:returns: A tinted image
	*/
	public func tintedHorizontallyWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode = kCGBlendModeNormal) -> UIImage {
		return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPointMake(0, 0.5), endPoint: CGPointMake(1.0, 0.5))
	}
	
	/**
	Create a gradient color tinted image
	References: http://stackoverflow.com/questions/8098130/how-can-i-tint-a-uiimage-with-gradient
	https://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage
	
	:param: colors     Gradient colors, from start point to end point.
	:param: blenMode   A blend mode.
	:param: startPoint The coordinate that defines the starting point of the gradient.
	:param: endPoint   The coordinate that defines the ending point of the gradient.
	
	:returns: A tinted image
	*/
	public func tintedWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode, startPoint: CGPoint, endPoint: CGPoint) -> UIImage {
		
		// Create a context with image size
		UIGraphicsBeginImageContext(CGSize(width: size.width * scale, height: size.height * scale))
		let context = UIGraphicsGetCurrentContext()

		// Translate and flip graphic to LLO
		context.flipCoordinatesVertically()
		
		// Draw image with CGImage and add mask
		let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
		CGContextDrawImage(context, rect, CGImage)
		CGContextClipToMask(context, rect, CGImage)
		
		// Translate and flip graphic to ULO
		context.flipCoordinatesVertically()
		
		// Blend Mode
		CGContextSetBlendMode(context, blenMode)
		
		// Add gradient colors
		let CGColors = colors.map { $0.CGColor }
		let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), CGColors, nil)
		let startPoint = CGPoint(x: size.width * scale * startPoint.x, y: size.height * scale * startPoint.y)
		let endPoint = CGPoint(x: size.width * scale * endPoint.x, y: size.height * scale * endPoint.y)
		let drawingOptions = CGGradientDrawingOptions(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, drawingOptions)
		
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return gradientImage
	}
	
	public func scaledImageToSize(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		drawInRect(CGRectMake(0, 0, size.width, size.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
