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
        return subviews.contains(view)
    }
    
    public func removeAllSubviews() {
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    public func removeAllSubviewsExceptView(view: UIView) {
        subviews.filter({ $0 != view }).forEach { $0.removeFromSuperview() }
    }
    
    public func removeAllSubviewsExceptViews(views: [UIView]) {
        subviews.filter({ views.contains($0) }).forEach { $0.removeFromSuperview() }
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
            let originalSelector = #selector(UIView.addGestureRecognizer(_:))
            let swizzledSelector = #selector(UIView.zhh_addGestureRecognizer(_:))
            
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
        
        // Good explanation of differences between drawViewHierarchyInRect:afterScreenUpdates: and renderInContext: https://github.com/radi/LiveFrost/issues/10#issuecomment-28959525
        layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     Get a snapshot (image representation) of this view.
     
     - returns: an Image snapshot.
     */
    public func snapshot() -> UIImage {
        return self.toImage()
    }
}
