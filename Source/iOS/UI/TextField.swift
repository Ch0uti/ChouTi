//
//  TextField.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-14.
//
//

import UIKit

public class TextField: UITextField {
	
	public var textHorizontalPadding: CGFloat = 10.0
	public var textVerticalPadding: CGFloat = 10.0
	
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
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
	
	public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
	
	public override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
}
