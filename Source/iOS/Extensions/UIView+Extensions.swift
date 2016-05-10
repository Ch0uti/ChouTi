//
//  UIView+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//

import UIKit

public extension UIView {
    
    /**
     Directly contaitns a view, not recursively
     
     - parameter view: child view
     
     - returns: true for directly contains, otherwise false
     */
    public func containSubview(view: UIView) -> Bool {
        if #available(iOS 9.0, *) {
            return subviews.contains(view)
        } else {
            return subviews.filter({$0 == view}).count > 0
        }
    }
    
    public func removeAllSubviews() {
        if #available(iOS 9.0, *) {
            subviews.forEach{ $0.removeFromSuperview() }
        } else {
            for subview in subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    public func removeAllSubviewsExceptView(view: UIView) {
        if #available(iOS 9.0, *) {
            subviews.filter({$0 != view}).forEach { $0.removeFromSuperview() }
        } else {
            for subview in subviews.filter({$0 != view}) {
                subview.removeFromSuperview()
            }
        }
    }
    
    public func removeAllSubviewsExceptViews(views: [UIView]) {
        if #available(iOS 9.0, *) {
            subviews.filter({ views.contains($0) }).forEach { $0.removeFromSuperview() }
        } else {
            for subview in subviews.filter({ views.contains($0) }) {
                subview.removeFromSuperview()
            }
        }
    }
}



// MARK: - Auto Layout
public extension UIView {
    public func constrainToFullSizeInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if #available(iOS 9.0, *) {
            constraints += [
                self.topAnchor.constraintEqualToAnchor(superview.topAnchor),
                self.leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor),
                self.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor),
                self.trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor)
            ]
        } else {
            constraints += [
                NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
            ]
        }
        
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constrainToFullSizeMarginInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if #available(iOS 9.0, *) {
            constraints += [
                self.topAnchor.constraintEqualToAnchor(superview.layoutMarginsGuide.topAnchor),
                self.leadingAnchor.constraintEqualToAnchor(superview.layoutMarginsGuide.leadingAnchor),
                self.bottomAnchor.constraintEqualToAnchor(superview.layoutMarginsGuide.bottomAnchor),
                self.trailingAnchor.constraintEqualToAnchor(superview.layoutMarginsGuide.trailingAnchor)
            ]
        } else {
            constraints += [
                NSLayoutConstraint(item: self, attribute: .TopMargin, relatedBy: .Equal, toItem: superview, attribute: .TopMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .LeadingMargin, relatedBy: .Equal, toItem: superview, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .BottomMargin, relatedBy: .Equal, toItem: superview, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .TrailingMargin, relatedBy: .Equal, toItem: superview, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0)
            ]
        }
        
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func centerInSuperview() -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("superview is nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if #available(iOS 9.0, *) {
            constraints += [
                self.centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor),
                self.centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor)
            ]
        } else {
            constraints += [
                NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            ]
        }
        
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constraintWidth(width: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            constraint = self.widthAnchor.constraintEqualToConstant(width)
        } else {
            constraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: width)
        }
        
        constraint.active = true
        return constraint
    }
    
    public func constraintHeight(height: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            constraint = self.heightAnchor.constraintEqualToConstant(height)
        } else {
            constraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: height)
        }
        
        constraint.active = true
        return constraint
    }
    
    public func constraintToSize(size: CGSize) -> [NSLayoutConstraint] {
        return [constraintWidth(size.width), constraintHeight(size.height)]
    }
}



// MARK: - Set Hidden
public extension UIView {
    /**
     Set hidden animated
     
     - parameter hidden:     hidden to set
     - parameter animated:   whether it's animated
     - parameter duration:   animation duration
     - parameter completion: completion block
     */
    public func setHidden(hidden: Bool, animated: Bool = false, duration: NSTimeInterval = 0.25, completion: ((Bool) -> ())? = nil) {
        if !animated {
            alpha = hidden ? 0.0 : 1.0
            self.hidden = hidden
            completion?(true)
        } else {
            // If to visible, set hidden to false first, then animate alpha
            if !hidden {
                self.hidden = hidden
            }
            
            UIView.animateWithDuration(duration, animations: {
                self.alpha = hidden ? 0.0 : 1.0
                }, completion: { (finished) -> Void in
                    self.hidden = hidden
                    completion?(finished)
            })
        }
    }
}



// MARK: - addGestureRecognizer Swizzling
public extension UIView {
    // Swizzling addGestureRecognizer(_: UIGestureRecognizer)
    public override class func initialize() {
        struct Static {
            static var addGestureRecognizerToken: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UIView.self {
            return
        }
        
        dispatch_once(&Static.addGestureRecognizerToken) {
            let originalSelector = Selector("addGestureRecognizer:")
            let swizzledSelector = Selector("zhh_addGestureRecognizer:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func zhh_addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        self.zhh_addGestureRecognizer(gestureRecognizer)
        
        if let longPressGesture = gestureRecognizer as? UILongPressGestureRecognizer {
            longPressGesture.setupForDetectingVelocity()
        }
    }
}



// MARK: - Utility
public extension UIView {
    /**
     Get the view controller presenting this view
     
     - returns: the view controller for presenting this view or nil
     */
    private func firstRespondedViewController() -> UIViewController? {
        if let viewController = nextResponder() as? UIViewController {
            return viewController
        } else if let view = nextResponder() as? UIView {
            return view.firstRespondedViewController()
        } else {
            return nil
        }
    }
    
    /// Get the view controller presenting this view
    public var presentingViewController: UIViewController? {
        return firstRespondedViewController()
    }
    
    /// Whether this view is currnetly visible
    public var isVisible: Bool {
        return window != nil
    }
}


// MARK: - CGRect Related
public extension UIView {
    /// Width for self
    public var width: CGFloat {
        get { return bounds.width }
        set { bounds.size.width = newValue }
    }
    
    /// Height for self
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
        get { return frame.leading }
        set { frame.leading = newValue }
    }
    
    /// trailing of frame, in Right-to-Left, trailing is left
    public var trailing: CGFloat {
        get { return frame.trailing }
        set { frame.trailing = newValue }
    }
    
    /**
     Get frame for self in another view
     
     - parameter view: the target view
     
     - returns: the frame of self in the target view
     */
    public func frameRectInView(view: UIView?) -> CGRect {
        return self.convertRect(self.bounds, toView: view)
    }
}

public extension UIView {
    /**
     Get a copy of the view. Note: this is not workinhg as expected
     
     - returns: A copy of the View
     */
    public func viewCopy() -> UIView {
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        let copy = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! UIView
        return copy
    }
}

public extension UIView {
    /**
     Get an image representation of this view.
     
     - returns: an Image.
     */
    public func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!
        layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
