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
    
    /**
     Deactivate this constraint
     
     - returns: self
     */
    public func deactivate() -> NSLayoutConstraint {
        active = false
        return self
    }
}

// MARK: - Auto Layout
public extension UIView {
    /**
     Setup full size in superview constraints
     
     - returns: newly added constraints
     */
    public func constrainToFullSizeInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else { fatalError("superview is nil") }
		return constrainTo(edgesOfView: superview)
    }
    
    /**
     Setup full size constraints relative to margin in superview
     
     - returns: newly added constraints
     */
    public func constrainToFullSizeMarginInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else { fatalError("superview is nil") }
        
        return [
            NSLayoutConstraint(item: self, attribute: .TopMargin, relatedBy: .Equal, toItem: superview, attribute: .TopMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .LeadingMargin, relatedBy: .Equal, toItem: superview, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .BottomMargin, relatedBy: .Equal, toItem: superview, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .TrailingMargin, relatedBy: .Equal, toItem: superview, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0)
        ].activate()
    }
    
    /**
     Setup center in superview constraints
     
     - returns: newly added constraints
     */
    public func constrainToCenterInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return [
            self.centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor),
            self.centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor)
        ].activate()
    }
    
    /**
     Setup constraint for horizontal center in super view.
     
     - returns: Constraint activated and added.
     */
    public func constrainToCenterHorizontallyInSuperview() -> NSLayoutConstraint {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return self.centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor).activate()
    }
    
    /**
     Setup constraint for vertical center in super view.
     
     - returns: Constraint activated and added.
     */
    public func constrainToCenterVerticallyInSuperview() -> NSLayoutConstraint {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        return self.centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor).activate()
    }
    
    /**
     Setup width constraint with width specified
     
     - parameter width: width to be set
     
     - returns: newly added constraint
     */
    public func constrainTo(width width: CGFloat) -> NSLayoutConstraint {
        return self.widthAnchor.constraintEqualToConstant(width).activate()
    }
    
    /**
     Setup height constraint with height specified
     
     - parameter height: height to be set
     
     - returns: newly added constraint
     */
    public func constrainTo(height height: CGFloat) -> NSLayoutConstraint {
        return self.heightAnchor.constraintEqualToConstant(height).activate()
    }
    
    /**
     Setup size constraints to view
     
     - parameter size: size to be set
     
     - returns: newly added constraint
     */
    public func constrainTo(size size: CGSize) -> [NSLayoutConstraint] {
        return [constrainTo(width: size.width), constrainTo(height: size.height)]
    }
    
    /**
     Setup width and height constraints.
     
     - parameter width:  width to be set.
     - parameter height: height to be set.
     
     - returns: constriants added.
     */
    public func constrainTo(width width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        return constrainTo(size: CGSize(width: width, height: height))
    }
    
    /**
     Constrain self to have same size and position of another view
     
     - parameter view: another view
     
     - returns: constraints added.
     */
    public func constrainTo(edgesOfView view: UIView) -> [NSLayoutConstraint] {
        return [
            self.topAnchor.constraintEqualToAnchor(view.topAnchor),
            self.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            self.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            self.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
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
    public func constrain(attribute1: NSLayoutAttribute, equalTo attribute2: NSLayoutAttribute, ofView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute1, relatedBy: .Equal, toItem: view, attribute: attribute2, multiplier: multiplier, constant: constant).activate()
    }
    
    /**
     Constrain self.attribute = view.attribute * multiplier + constant
     
     - parameter attribute:  attribute
     - parameter view:       another view
     - parameter multiplier: multiplier
     - parameter constant:   constant
     
     - returns: constraint added.
     */
    public func constrain(attribute: NSLayoutAttribute, toView view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constrain(attribute, equalTo: attribute, ofView: view, multiplier: multiplier, constant: constant)
    }
}

public extension SequenceType where Generator.Element: UIView {
    /**
     Setup constraints for a list of UIViews, two adjacent views have same attribute.
     Those constraints are activated.
     
     - parameter attribute: a NSLayoutAttribute
     
     - returns: a list of constraints.
     */
    public func constrainToSame(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        var last: UIView?
        var generator = self.generate()
        while let next = generator.next() {
            defer {
                last = next
            }
            
            guard let lastView = last else {
                continue
            }
            
            constraints.append(NSLayoutConstraint(item: lastView, attribute: attribute, relatedBy: .Equal, toItem: next, attribute: attribute, multiplier: 1.0, constant: 0.0))
        }
        
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
}

public extension CollectionType where Generator.Element: NSLayoutConstraint {
    /**
     Activate constraints
     
     - returns: self
     */
    public func activate() -> Self {
        self.forEach { $0.active = true }
        return self
    }
    
    /**
     Deactivate constraints
     
     - returns: self
     */
    public func deactivate() -> Self {
        self.forEach { $0.active = false }
        return self
    }
}
