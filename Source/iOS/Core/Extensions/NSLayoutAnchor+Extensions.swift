//
//  NSLayoutAnchor.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-08-13.
//
//

import Foundation

public extension NSLayoutAnchor {
    public func constrainTo(anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, constant: constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(anchor: NSLayoutAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
    }
}

public extension NSLayoutDimension {

    public func constrainTo(constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalToConstant: constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualToConstant: constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(onstant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualToConstant: constant).activate()
    }
    
    public func constrainTo(anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
    
    public func constrainGreaterThanOrEqualTo(anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
    
    public func constrainLessThanOrEqualTo(anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
}
