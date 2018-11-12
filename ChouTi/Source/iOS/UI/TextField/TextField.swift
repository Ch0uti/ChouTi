//
//  Created by Honghao Zhang on 11/14/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
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
    override open var placeholder: String? {
        didSet {
            guard let placeholder = placeholder else {
                return
            }

            if placeholderFont != nil || placeholderColor != nil {
                var attributes = [NSAttributedString.Key: Any]()
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

            var attributes = [NSAttributedString.Key: Any]()
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

            var attributes = [NSAttributedString.Key: Any]()
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

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return customizedTextRectForBounds(bounds)
    }

    private func customizedTextRectForBounds(_ bounds: CGRect) -> CGRect {
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
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= layoutMargins.right
        return rect
    }

    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += layoutMargins.left
        return rect
    }
}
