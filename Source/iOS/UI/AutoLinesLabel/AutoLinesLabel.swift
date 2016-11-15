//
//  AutoLinesLabel.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2014-12-18.
//

import UIKit

open class AutoLinesLabel: UILabel {
	open var contentInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            // Force label to update
            let originalText = self.text
            self.text = ""
            self.text = originalText
            self.superview?.setNeedsLayout()
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
	
    fileprivate func commonInit() {
        // Content is never compressed
        self.setContentCompressionResistancePriority(1000, for: .horizontal)
        self.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let targetWidth = bounds.width
		// Once label's width is changed, update preferredMaxLayoutWidth, this will lead recall textRectForBounds
        if self.preferredMaxLayoutWidth != targetWidth {
            self.preferredMaxLayoutWidth = targetWidth
        }
        self.superview?.setNeedsLayout()
    }
    
    open override func drawText(in rect: CGRect) {
        // Rect has been veritcally expanded in textRectForBounds
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInset))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // Use a shrinked rect to calculate new rect, this will lead to a higher rectangle to draw
        // The width is same as preferredMaxLayoutWidth
        // Reference: http://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accomodate-insets
        
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, contentInset), limitedToNumberOfLines: numberOfLines)
        // Move rect to origin
        rect.origin.x    -= contentInset.left;
        rect.origin.y    -= contentInset.top;
        rect.size.width  += (contentInset.left + contentInset.right);
        rect.size.height += (contentInset.top + contentInset.bottom);
        return rect
    }
}
