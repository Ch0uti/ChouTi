//
//  UILable+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UILabel {

    /**
     Get exact size for UILabel, computed with text and font on this label
     
     - returns: CGSize for this label
     */
    @available(*, deprecated: 1.0)
    func exactSize_deprecated() -> CGSize {
        if let text = text {
            let text: NSString = text as NSString
            var newSize = text.size(withAttributes: [.font: font])
            newSize.width = ceil(newSize.width)
            newSize.height = ceil(newSize.height)
            return newSize
        } else {
            return CGSize.zero
        }
    }

    /**
     Get exact size for UILabel, computed with text and font on this label.
     
     - parameter preferredMaxWidth: Preferred nax width for the calculation.
     - parameter shouldUseCeil:     Whether size should be round up to integers.
     
     - returns: Exact size for this label.
     */
    func exactSize(preferredMaxWidth: CGFloat? = nil, shouldUseCeil: Bool = false) -> CGSize {
        var size = self.sizeThatFits(CGSize(width: preferredMaxWidth ?? preferredMaxLayoutWidth, height: 0))

        if shouldUseCeil {
            size.width = ceil(size.width)
            size.height = ceil(size.height)
        }

        return size
    }

    /**
     The size of the smallest permissible font with which to draw the label’s text.
     Note: If adjustsFontSizeToFitWidth == false, return fixed size
     
     :returns: minimum font size
     */
    func smallestFontSize() -> CGFloat {
        if adjustsFontSizeToFitWidth == true {
            return font.pointSize * minimumScaleFactor
        } else {
            return font.pointSize
        }
    }
}

// MARK: - Animations
public extension UILabel {

    /**
     Add a fade in/out text transition animation
     Note: Must be called after label has been displayed
     
     - parameter animationDuration: transition animation duration
     */
    func addFadeTransitionAnimation(_ animationDuration: TimeInterval = 0.25) {
        if layer.animation(forKey: convertFromCATransitionType(CATransitionType.fade)) == nil {
            let animation = CATransition()
            animation.duration = animationDuration
            animation.type = CATransitionType.fade
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.fade))
        }
    }

    /**
     Set text with fade in transition animation.
     
     - parameter text:              New text to set.
     - parameter animationDuration: Animation duration.
     */
    func setText(_ text: String?, withFadeTransitionAnimation animationDuration: TimeInterval) {
        addFadeTransitionAnimation(animationDuration)
        self.text = text
    }

    /**
     Set text with default fade in transition animation if animated.
     
     - parameter text:     New text to set.
     - parameter animated: Animation duration.
     */
    func setText(_ text: String?, animated: Bool) {
        if animated {
            setText(text, withFadeTransitionAnimation: 0.25)
        } else {
            self.text = text
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}
