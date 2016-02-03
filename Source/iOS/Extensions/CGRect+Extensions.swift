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
            let newHeight = newValue - top
            size.height = newHeight > 0 ? newHeight : 0.0
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
            let newWidth = newValue - left
            size.width = newWidth > 0 ? newWidth : 0.0
        }
    }
    
    /// Mostly it's left, in Right-to-Left, leading is right
    public var leading: CGFloat {
        get { return isRTL ? right : left }
        set { isRTL ? (right = newValue) : (left = newValue) }
    }
    
    /// Mostly it's right, in Right-to-Left, trailing is left
    public var trailing: CGFloat {
        get { return isRTL ? left : right }
        set { isRTL ? (left = newValue) : (right = newValue) }
    }
    
    /// whether system interfae is Right-to-Left
    private var isRTL: Bool {
        return UIApplication.sharedApplication().userInterfaceLayoutDirection == .RightToLeft
    }
}
