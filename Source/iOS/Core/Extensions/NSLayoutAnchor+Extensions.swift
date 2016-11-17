//
//  NSLayoutAnchor.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-08-13.
//
//

import Foundation

public extension NSLayoutXAxisAnchor {
	@discardableResult
    public func constrain(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, constant: constant).activate()
    }
	
	@discardableResult
    public func constrain(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
    }
	
	@discardableResult
    public func constrain(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
    }
}

public extension NSLayoutYAxisAnchor {
	@discardableResult
	public func constrain(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(equalTo: anchor, constant: constant).activate()
	}
	
	@discardableResult
	public func constrain(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
	}
	
	@discardableResult
	public func constrain(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
	}
}

public extension NSLayoutDimension {
	@discardableResult
	public func constrain(to anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(equalTo: anchor, constant: constant).activate()
	}
	
	@discardableResult
	public func constrain(greaterThanOrEqualTo anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
	}
	
	@discardableResult
	public func constrain(lessThanOrEqualTo anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
	}
}

public extension NSLayoutDimension {

	@discardableResult
    public func constrain(to constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalToConstant: constant).activate()
    }
	
	@discardableResult
    public func constrain(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualToConstant: constant).activate()
    }
	
	@discardableResult
    public func constrain(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualToConstant: constant).activate()
    }
	
	@discardableResult
    public func constrain(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
	
	@discardableResult
    public func constrain(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
	
	@discardableResult
    public func constrain(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
}
