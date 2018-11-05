//
//  UIScrollView+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-13.
//
//

import UIKit

public extension UIScrollView {
    /**
     Scrolls ScrollView to the top
     
     - parameter animated: whether it's animated
     */
    func scrollsToTop(animated: Bool) {
        setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
    }

    /**
     Scrolls ScrollView to the bottom
     
     - parameter animated: whether it's animated
     */
    func scrollsToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: contentOffset.x, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}
