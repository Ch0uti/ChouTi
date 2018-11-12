//
//  UIView+Geometry.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

// MARK: - CGRect Related
public extension UIView {
    /// Width for self
    var width: CGFloat {
        get { return bounds.width }
        set { bounds.size.width = newValue }
    }

    /// Height for self
    var height: CGFloat {
        get { return bounds.height }
        set { bounds.size.height = newValue }
    }

    /// Size
    var size: CGSize {
        get { return bounds.size }
        set { bounds.size = newValue }
    }

    /// `x` of `frame`
    var x: CGFloat {
        get { return frame.x }
        set { frame.x = newValue }
    }

    /// `y` of `frame`
    var y: CGFloat {
        get { return frame.y }
        set { frame.y = newValue }
    }

    /// `top` of `frame`, which is `y`
    var top: CGFloat {
        get { return frame.top }
        set { frame.top = newValue }
    }

    /// `bottom` of `frame`, which is `y + height`
    var bottom: CGFloat {
        get { return frame.bottom }
        set { frame.bottom = newValue }
    }

    /// `left` of `frame`, which is `x`
    var left: CGFloat {
        get { return frame.left }
        set { frame.left = newValue }
    }

    /// `right` of `frame`, which is `x + width`
    var right: CGFloat {
        get { return frame.right }
        set { frame.right = newValue }
    }

    /// `leading` of `frame`, in Right-to-Left, `leading` is `right`
    var leading: CGFloat {
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

    /// `trailing` of `frame`, in Right-to-Left, `trailing` is `left`
    var trailing: CGFloat {
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
