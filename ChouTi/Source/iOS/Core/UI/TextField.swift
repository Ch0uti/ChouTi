//
//  TextField.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-14.
//
//

import UIKit

open class TextField: UITextField {
    /// Cursor Color
    open var cursorColor: UIColor? {
        didSet {
            tintColor = cursorColor
        }
    }
    
    /// Placeholder text
    open override var placeholder: String? {
        didSet {
            guard let placeholder = placeholder else {
                return
            }
            
            if placeholderFont != nil || placeholderColor != nil {
                var attributes = [NSAttributedStringKey : Any]()
                if let placeholderColor = placeholderColor {
                    attributes[.foregroundColor] = placeholderColor
                }
                
                if let placeholderFont = placeholderFont {
                    attributes[.font] = placeholderFont
                }
                
                let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
                
                attributedPlaceholder = attributedString
            }
        }
    }
    
    /// Placeholder text color
    open var placeholderColor: UIColor? {
        didSet {
            guard let placeholder = placeholder else {
                return
            }
            
            var attributes = [NSAttributedStringKey : Any]()
            if let placeholderColor = placeholderColor {
                attributes[.foregroundColor] = placeholderColor
            }
            
            if let placeholderFont = placeholderFont {
                attributes[.font] = placeholderFont
            }
            
            let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
            
            attributedPlaceholder = attributedString
        }
    }
    
    /// Placeholder text font
    open var placeholderFont: UIFont? {
        didSet {
            guard let placeholder = placeholder else {
                return
            }
            
            var attributes = [NSAttributedStringKey : Any]()
            if let placeholderColor = placeholderColor {
                attributes[.foregroundColor] = placeholderColor
            }
            
            if let placeholderFont = placeholderFont {
                attributes[.font] = placeholderFont
            }
            
            let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
            
            attributedPlaceholder = attributedString
        }
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }
    
    fileprivate func customizedTextRectForBounds(_ bounds: CGRect) -> CGRect {
        var textRect = bounds
        let leftViewRect = self.leftViewRect(forBounds: bounds)
        let rightViewRect = self.rightViewRect(forBounds: bounds)
        
        textRect.origin.x = (leftViewRect.origin.x + leftViewRect.width) + layoutMargins.left
        textRect.origin.y = layoutMargins.top
        textRect.size.width = textRect.width - ((leftViewRect.origin.x + leftViewRect.width) + layoutMargins.left) - (layoutMargins.right * 2 + rightViewRect.width)
        textRect.size.height = textRect.height - layoutMargins.top - layoutMargins.bottom
        return textRect
    }
}

extension TextField {
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= layoutMargins.right
        return rect
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += layoutMargins.left
        return rect
    }
}
