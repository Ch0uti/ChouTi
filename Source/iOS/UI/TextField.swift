//
//  TextField.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-14.
//
//

import UIKit

public class TextField: UITextField {
	
	public var cursorColor: UIColor? {
		didSet {
			tintColor = cursorColor
		}
	}
	
	public override var placeholder: String? {
		didSet {
			guard let placeholder = placeholder else {
				return
			}
			
			if placeholderFont != nil || placeholderColor != nil {
				var attributes = [String : AnyObject]()
				if let placeholderColor = placeholderColor {
					attributes[NSForegroundColorAttributeName] = placeholderColor
				}
				
				if let placeholderFont = placeholderFont {
					attributes[NSFontAttributeName] = placeholderFont
				}
				
				let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
				
				attributedPlaceholder = attributedString
			}
		}
	}
	
	public var placeholderColor: UIColor? {
		didSet {
			guard let placeholder = placeholder else {
				return
			}
			
			var attributes = [String : AnyObject]()
			if let placeholderColor = placeholderColor {
				attributes[NSForegroundColorAttributeName] = placeholderColor
			}
			
			if let placeholderFont = placeholderFont {
				attributes[NSFontAttributeName] = placeholderFont
			}
			
			let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
			
			attributedPlaceholder = attributedString
		}
	}
	
	public var placeholderFont: UIFont? {
		didSet {
			guard let placeholder = placeholder else {
				return
			}
			
			var attributes = [String : AnyObject]()
			if let placeholderColor = placeholderColor {
				attributes[NSForegroundColorAttributeName] = placeholderColor
			}
			
			if let placeholderFont = placeholderFont {
				attributes[NSFontAttributeName] = placeholderFont
			}
			
			let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
			
			attributedPlaceholder = attributedString
		}
	}
	
	public override func textRectForBounds(bounds: CGRect) -> CGRect {
		return customizedTextRectForBounds(bounds)
	}
	
	public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
		return customizedTextRectForBounds(bounds)
	}
	
	public override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return customizedTextRectForBounds(bounds)
	}
	
	private func customizedTextRectForBounds(bounds: CGRect) -> CGRect {
		var textRect = bounds
		let leftViewRect = leftViewRectForBounds(bounds)
		let rightViewRect = rightViewRectForBounds(bounds)
		
		textRect.origin.x = leftViewRect.right + layoutMargins.left
		textRect.origin.y = layoutMargins.top
		textRect.size.width = textRect.width - (leftViewRect.right + layoutMargins.left) - (layoutMargins.right * 2 + rightViewRect.width)
		textRect.size.height = textRect.height - layoutMargins.top - layoutMargins.bottom
		return textRect
	}
}

extension TextField {
	public override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
		var rect = super.rightViewRectForBounds(bounds)
		rect.origin.x -= layoutMargins.right
		return rect
	}
	
	public override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
		var rect = super.leftViewRectForBounds(bounds)
		rect.origin.x += layoutMargins.left
		return rect
	}
}
