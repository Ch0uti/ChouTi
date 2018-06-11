//
//  NSLayoutConstraint+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-04.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

// TODO: https://github.com/roberthein/TinyConstraints

public extension NSLayoutConstraint {
    /**
     Activate this constraint
     
     - returns: self
     */
	@discardableResult
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
    
    /**
     Deactivate this constraint
     
     - returns: self
     */
	@discardableResult
    public func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }
}

// MARK: - Auto Layout
public extension UIView {
    /**
     Setup full size in superview constraints
     
     - returns: newly added constraints
     */
	@discardableResult
    public func constrainToFullSizeInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else { fatalError("superview is nil") }
		return constrainTo(edgesOfView: superview)
    }
    
    /**
     Setup full size constraints relative to margin in superview
     
     - returns: newly added constraints
     */
	@discardableResult
    public func constrainToFullSizeMarginInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else { fatalError("superview is nil") }
        
        return [
            NSLayoutConstraint(item: self, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0)
        ].activate()
    }
    
    /**
     Setup center in superview constraints
     
     - returns: newly added constraints
     */
	@discardableResult
    public func constrainToCenterInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return [
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ].activate()
    }
    
    /**
     Setup constraint for horizontal center in super view.
     
     - returns: Constraint activated and added.
     */
	@discardableResult
    public func constrainToCenterHorizontallyInSuperview() -> NSLayoutConstraint {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).activate()
    }
    
    /**
     Setup constraint for vertical center in super view.
     
     - returns: Constraint activated and added.
     */
	@discardableResult
    public func constrainToCenterVerticallyInSuperview() -> NSLayoutConstraint {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).activate()
    }
    
    /**
     Setup width constraint with width specified
     
     - parameter width: width to be set
     
     - returns: newly added constraint
     */
	@discardableResult
    public func constrainTo(width: CGFloat) -> NSLayoutConstraint {
        return self.widthAnchor.constraint(equalToConstant: width).activate()
    }
    
    /**
     Setup height constraint with height specified
     
     - parameter height: height to be set
     
     - returns: newly added constraint
     */
	@discardableResult
    public func constrainTo(height: CGFloat) -> NSLayoutConstraint {
        return self.heightAnchor.constraint(equalToConstant: height).activate()
    }
    
    /**
     Setup size constraints to view
     
     - parameter size: size to be set
     
     - returns: newly added constraint
     */
	@discardableResult
    public func constrainTo(size: CGSize) -> [NSLayoutConstraint] {
        return [constrainTo(width: size.width), constrainTo(height: size.height)]
    }
    
    /**
     Setup width and height constraints.
     
     - parameter width:  width to be set.
     - parameter height: height to be set.
     
     - returns: constriants added.
     */
	@discardableResult
    public func constrainTo(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        return constrainTo(size: CGSize(width: width, height: height))
    }
    
    /**
     Constrain self to have same size and position of another view
     
     - parameter view: another view
     
     - returns: constraints added.
     */
	@discardableResult
    public func constrainTo(edgesOfView view: UIView) -> [NSLayoutConstraint] {
        return [
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].activate()
    }
    
    /**
     Constrain self.attribute1 = view.attribute2 * multiplier + constant
     
     - parameter attribute1: attribute1
     - parameter attribute2: attribute2
     - parameter view:       another view
     - parameter multiplier: multiplier
     - parameter constant:   constant
     
     - returns: constraint added.
     */
	@discardableResult
    public func constrain(_ attribute1: NSLayoutAttribute, equalTo attribute2: NSLayoutAttribute, ofView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute1, relatedBy: .equal, toItem: view, attribute: attribute2, multiplier: multiplier, constant: constant).activate()
    }
    
    /**
     Constrain self.attribute = view.attribute * multiplier + constant
     
     - parameter attribute:  attribute
     - parameter view:       another view
     - parameter multiplier: multiplier
     - parameter constant:   constant
     
     - returns: constraint added.
     */
	@discardableResult
    public func constrain(_ attribute: NSLayoutAttribute, toView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constrain(attribute, equalTo: attribute, ofView: view, multiplier: multiplier, constant: constant)
    }
}

public extension Sequence where Iterator.Element: UIView {
    /**
     Setup constraints for a list of UIViews, two adjacent views have same attribute.
     Those constraints are activated.
     
     - parameter attribute: a NSLayoutAttribute
     
     - returns: a list of constraints.
     */
	@discardableResult
    public func constrainToSame(_ attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        var last: UIView?
        var generator = self.makeIterator()
        while let next = generator.next() {
            defer {
                last = next
            }
            
            guard let lastView = last else {
                continue
            }
            
            constraints.append(NSLayoutConstraint(item: lastView, attribute: attribute, relatedBy: .equal, toItem: next, attribute: attribute, multiplier: 1.0, constant: 0.0))
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

public extension Collection where Iterator.Element: NSLayoutConstraint {
    /**
     Activate constraints
     
     - returns: self
     */
	@discardableResult
    public func activate() -> Self {
        self.forEach { $0.isActive = true }
        return self
    }
    
    /**
     Deactivate constraints
     
     - returns: self
     */
	@discardableResult
    public func deactivate() -> Self {
        self.forEach { $0.isActive = false }
        return self
    }
}
