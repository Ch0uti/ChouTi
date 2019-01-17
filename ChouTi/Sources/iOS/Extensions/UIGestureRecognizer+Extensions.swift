//
//  Created by Honghao Zhang on 8/16/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UIGestureRecognizer {
    /**
     Calls `requireGestureRecognizerToFail(_:)`
     
     - parameter otherGestureRecognizer: otherGestureRecognizer
     */
    func setToDependOn(_ otherGestureRecognizer: UIGestureRecognizer) {
        self.require(toFail: otherGestureRecognizer)
    }
}
