// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

open class AutoLinesLabel: UILabel {
    open var contentInset = UIEdgeInsets.zero {
        didSet {
            // Force label to update
            let originalText = text
            text = ""
            text = originalText
            superview?.setNeedsLayout()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        // Content is never compressed
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let targetWidth = bounds.width
        // Once label's width is changed, update preferredMaxLayoutWidth, this will lead recall textRectForBounds
        if preferredMaxLayoutWidth != targetWidth {
            preferredMaxLayoutWidth = targetWidth
        }
        superview?.setNeedsLayout()
    }

    open override func drawText(in rect: CGRect) {
        // Rect has been veritcally expanded in textRectForBounds
        super.drawText(in: rect.inset(by: contentInset))
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // Use a shrinked rect to calculate new rect, this will lead to a higher rectangle to draw
        // The width is same as preferredMaxLayoutWidth
        // Reference: http://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accomodate-insets

        var rect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        // Move rect to origin
        rect.origin.x -= contentInset.left
        rect.origin.y -= contentInset.top
        rect.size.width += (contentInset.left + contentInset.right)
        rect.size.height += (contentInset.top + contentInset.bottom)
        return rect
    }
}
