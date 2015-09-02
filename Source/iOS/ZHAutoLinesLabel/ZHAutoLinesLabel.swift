//
//  ZHAutoLinesLabel.swift
//  ZHAutoLinesLabel
//
//  Created by Honghao Zhang on 2014-12-18.
//  Copyright (c) 2014 HonghaoZ. All rights reserved.
//

import UIKit

class ZHAutoLinesLabel: UILabel {
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            // Force label to update
            let originalText = self.text
            self.text = ""
            self.text = originalText
            self.superview?.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Content is never compressed
        self.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        self.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let targetWidth = CGRectGetWidth(self.bounds)
        // Once label's widht is changed, update preferredMaxLayoutWidth, this will lead recall textRectForBounds
        if self.preferredMaxLayoutWidth != targetWidth {
            self.preferredMaxLayoutWidth = targetWidth
            self.superview?.setNeedsLayout()
        }
        self.superview?.setNeedsLayout()
    }
    
    override func drawTextInRect(rect: CGRect) {
        // Rect has been veritcally expanded in textRectForBounds
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, contentInset))
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // Use a shrinked rect to calculate new rect, this will lead to a higher rectangle to draw
        // The width is same as preferredMaxLayoutWidth
        // Reference: http://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accomodate-insets
        
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, contentInset), limitedToNumberOfLines: numberOfLines)
        // Move rect to origin
        rect.origin.x    -= contentInset.left;
        rect.origin.y    -= contentInset.top;
        rect.size.width  += (contentInset.left + contentInset.right);
        rect.size.height += (contentInset.top + contentInset.bottom);
        return rect
    }
}
