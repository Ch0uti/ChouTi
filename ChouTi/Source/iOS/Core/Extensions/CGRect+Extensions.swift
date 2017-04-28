//
//  CGRect+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-09.
//
//

import Foundation

public extension CGRect {
    /// x
    public var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    /// y
    public var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    /// y
    public var top: CGFloat {
        get { return y }
        set { y = newValue }
    }
    
    /// y + height
    public var bottom: CGFloat {
        get { return y + height }
        set {
            origin.y = newValue - height
        }
    }
    
    /// x
    public var left: CGFloat {
        get { return x }
        set { x = newValue }
    }
    
    /// x + width
    public var right: CGFloat {
        get { return x + width }
        set {
            origin.x = newValue - width
        }
    }
}
