//
//  UILable+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-04.
//
//

import UIKit

public extension UILabel {
	/**
	Get exact size for UILabel, computed with text and font on this label
	
	:returns: CGSize for this label
	*/
	public func exactSize() -> CGSize {
		if let text = text {
			let text: NSString = text
			var newSize = text.sizeWithAttributes([NSFontAttributeName: font])
			newSize.width = ceil(newSize.width)
			newSize.height = ceil(newSize.height)
			return newSize
		} else {
			return CGSizeZero
		}
	}
	
	/**
	The size of the smallest permissible font with which to draw the label’s text.
	Note: If adjustsFontSizeToFitWidth == false, return fixed size
	
	:returns: minimum font size
	*/
	public func smallestFontSize() -> CGFloat {
		if adjustsFontSizeToFitWidth == true {
			return font.pointSize * minimumScaleFactor
		} else {
			return font.pointSize
		}
	}
}
