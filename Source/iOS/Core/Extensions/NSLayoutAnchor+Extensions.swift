//
//  NSLayoutAnchor.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-08-13.
//
//

import Foundation

public extension NSLayoutAnchor {
    public func constrainTo(anchor anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintEqualToAnchor(anchor, constant: constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(anchor anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintGreaterThanOrEqualToAnchor(anchor, constant: constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(anchor anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintLessThanOrEqualToAnchor(anchor, constant: constant).activate()
    }
}

public extension NSLayoutDimension {

    public func constrainTo(constant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraintEqualToConstant(constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(constant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraintGreaterThanOrEqualToConstant(constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(onstant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraintLessThanOrEqualToConstant(constant).activate()
    }
    
    public func constrainTo(anchor anchor: NSLayoutDimension, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintEqualToAnchor(anchor, multiplier: multiplier, constant: constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(anchor anchor: NSLayoutDimension, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintGreaterThanOrEqualToAnchor(anchor, multiplier: multiplier, constant: constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(anchor anchor: NSLayoutDimension, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraintLessThanOrEqualToAnchor(anchor, multiplier: multiplier, constant: constant).activate()
    }
}
