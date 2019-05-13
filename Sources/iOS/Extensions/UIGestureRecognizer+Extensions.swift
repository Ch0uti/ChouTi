// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UIGestureRecognizer {
    /**
     Calls `requireGestureRecognizerToFail(_:)`

     - parameter otherGestureRecognizer: otherGestureRecognizer
     */
    func setToDependOn(_ otherGestureRecognizer: UIGestureRecognizer) {
        require(toFail: otherGestureRecognizer)
    }
}
