//
//  CGRect+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-09.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension CGRect {
    /// `x`
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }

    /// `y`
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }

    /// `y`
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }

    /// `y + height`
    var bottom: CGFloat {
        get { return y + height }
        set {
            origin.y = newValue - height
        }
    }

    /// `x`
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }

    /// `x + width`
    var right: CGFloat {
        get { return x + width }
        set {
            origin.x = newValue - width
        }
    }
}
