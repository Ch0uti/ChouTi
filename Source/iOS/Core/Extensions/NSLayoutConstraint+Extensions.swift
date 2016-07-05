//
//  NSLayoutConstraint+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-04.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    /**
     Activate this constraint
     
     - returns: self
     */
    public func activate() -> NSLayoutConstraint {
        active = true
        return self
    }
}
