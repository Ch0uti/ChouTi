// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UIScrollView {
    /**
     Scrolls to the top.

     - parameter animated: whether it's animated.
     */
    func scrollsToTop(animated: Bool) {
        setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
    }

    /**
     Scrolls to the bottom with content inset included.

     - parameter animated: whether it's animated.
     */
    func scrollsToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: contentOffset.x,
                                   y: contentSize.height - bounds.height + adjustedContentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}
