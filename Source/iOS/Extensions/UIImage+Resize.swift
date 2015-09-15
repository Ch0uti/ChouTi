//
//  UIImage+Resize.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-11.
//

import UIKit

extension UIImage {
	func scaledToMaxWidth(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
		let oldWidth = self.size.width
		let oldHeight = self.size.height
		
		let scaleFactor = (oldWidth > oldHeight) ? maxWidth / oldWidth : maxHeight / oldHeight
		
		let newWidth = oldWidth * scaleFactor
		let newHeight = oldHeight * scaleFactor
		
		let newSize = CGSize(width: newWidth, height: newHeight)
		
		return self.scaledToSize(newSize)
	}
	
	func scaledToSize(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		
		self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return newImage
	}
}
