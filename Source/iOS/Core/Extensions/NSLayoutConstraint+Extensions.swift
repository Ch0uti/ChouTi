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
}

// MARK: - Auto Layout
public extension UIView {
    /**
     Setup full size in superview constraints
     
     - returns: newly added constraints
     */
    public func constrainToFullSizeInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        return [
            self.topAnchor.constraintEqualToAnchor(superview.topAnchor),
            self.leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor),
            self.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor),
            self.trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor)
        ].activate()
    }
    
    /**
     Setup full size constraints relative to margin in superview
     
     - returns: newly added constraints
     */
    public func constrainToFullSizeMarginInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
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
        
        translatesAutoresizingMaskIntoConstraints = false
        
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
        
        translatesAutoresizingMaskIntoConstraints = false
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
        
        translatesAutoresizingMaskIntoConstraints = false
        return self.centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor).activate()
    }
    
    /**
     Setup width constraint with width specified
     
     - parameter width: width to be set
     
     - returns: newly added constraint
     */
    public func constrainTo(width width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return self.widthAnchor.constraintEqualToConstant(width).activate()
    }
    
    /**
     Setup height constraint with height specified
     
     - parameter height: height to be set
     
     - returns: newly added constraint
     */
    public func constrainTo(height height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
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
        translatesAutoresizingMaskIntoConstraints = false
        return [
            self.topAnchor.constraintEqualToAnchor(view.topAnchor),
            self.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            self.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            self.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        ].activate()
    }
    
    /**
     Snap self.top to bottom of another view
     
     - parameter view: view to snap to.
     
     - returns: constraint activated and added.
     */
    public func constrainTo(bottomOfView view: UIView) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return self.topAnchor.constraintEqualToAnchor(view.bottomAnchor).activate()
    }
    
    /**
     Snap self.top to bottom of another view, with constant
     
     - parameter view:     view to snap to.
     - parameter constant: constant activated and added.
     
     - returns: constraint activated and added.
     */
    public func constrainTo(bottomOfView view: UIView, constant: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return self.topAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: constant).activate()
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
}
