//
//  UIGestureRecognizer+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-16.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

public extension UIGestureRecognizer {
    /**
     Calls `requireGestureRecognizerToFail(_:)`
     
     - parameter otherGestureRecognizer: otherGestureRecognizer
     */
    public func setToDependOn(_ otherGestureRecognizer: UIGestureRecognizer) {
        self.require(toFail: otherGestureRecognizer)
    }
}
