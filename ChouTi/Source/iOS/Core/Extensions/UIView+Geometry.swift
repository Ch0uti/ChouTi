//
//  UIView+Geometry.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

// MARK: - CGRect Related
public extension UIView {
    /// width for self
    public var width: CGFloat {
        get { return bounds.width }
        set { bounds.size.width = newValue }
    }
    
    /// height for self
    public var height: CGFloat {
        get { return bounds.height }
        set { bounds.size.height = newValue }
    }
    
    /// Size
    public var size: CGSize {
        get { return bounds.size }
        set { bounds.size = newValue }
    }
    
    /// x of frame
    public var x: CGFloat {
        get { return frame.x }
        set { frame.x = newValue }
    }
    
    /// y of frame
    public var y: CGFloat {
        get { return frame.y }
        set { frame.y = newValue }
    }
    
    /// top of frame, which is y
    public var top: CGFloat {
        get { return frame.top }
        set { frame.top = newValue }
    }
    
    /// bottom of frame, which is y + height
    public var bottom: CGFloat {
        get { return frame.bottom }
        set { frame.bottom = newValue }
    }
    
    /// left of frame, which is x
    public var left: CGFloat {
        get { return frame.left }
        set { frame.left = newValue }
    }
    
    /// right of frame, which is x + width
    public var right: CGFloat {
        get { return frame.right }
        set { frame.right = newValue }
    }
    
    /// leading of frame, in Right-to-Left, leading is right
    public var leading: CGFloat {
        get {
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                return frame.left
            } else {
                return frame.right
            }
        }
        
        set {
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                return frame.left = newValue
            } else {
                return frame.right = newValue
            }
        }
    }
    
    /// trailing of frame, in Right-to-Left, trailing is left
    public var trailing: CGFloat {
        get {
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                return frame.right
            } else {
                return frame.left
            }
        }
        
        set {
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                return frame.right = newValue
            } else {
                return frame.left = newValue
            }
        }
    }
}
