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
    public func containSubview(_ view: UIView) -> Bool {
        return subviews.contains(view)
    }
    
    public func removeAllSubviews() {
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    public func removeAllSubviewsExceptView(_ view: UIView) {
        subviews.filter({ $0 != view }).forEach { $0.removeFromSuperview() }
    }
    
    public func removeAllSubviewsExceptViews(_ views: [UIView]) {
        subviews.filter({ views.contains($0) }).forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Set Hidden
public extension UIView {
	/**
	Set hidden animated with completion.
	
	- parameter toHide:     New hidden value to set.
	- parameter animated:   Whether setting should be animated
	- parameter duration:   Animation duration.
	- parameter completion: Completion block.
	*/
    public func setHidden(_ toHide: Bool, animated: Bool = false, duration: TimeInterval = 0.25, completion: ((Bool) -> ())? = nil) {
        if self.isHidden == toHide && alpha == (toHide ? 0.0 : 1.0) {
            completion?(false)
            return
        }
        
        if animated == false {
            alpha = toHide ? 0.0 : 1.0
            self.isHidden = toHide
            completion?(true)
        } else {
            // If is to visible, set hidden to false first, then animate alpha
            if toHide == false {
                self.isHidden = toHide
                if alpha == 1.0 {
                    debugPrint("\(self) has an alpha: 1.0, animation maybe broken.")
                }
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = toHide ? 0.0 : 1.0
            }, completion: { finished -> Void in
                self.isHidden = toHide
                completion?(finished)
            })
        }
    }
}



// MARK: - Utility
public extension UIView {
    /**
     Get the view controller presenting this view
     
     - returns: the view controller for presenting this view or nil
     */
    fileprivate func firstRespondedViewController() -> UIViewController? {
        if let viewController = next as? UIViewController {
            return viewController
        } else if let view = next as? UIView {
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
    public func frameRectInView(_ view: UIView?) -> CGRect {
        return self.convert(self.bounds, to: view)
    }
    
    /// Get bounds of screen, which is presenting this view.
    var screenBounds: CGRect? {
        guard let window = window else { return nil }
        return window.convert(window.bounds, to: nil)
    }
}

public extension UIView {
    /**
     Get a copy of the view. Note: this is not workinhg as expected
     
     - returns: A copy of the View
     */
    public func viewCopy() -> UIView {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        let copy = NSKeyedUnarchiver.unarchiveObject(with: data) as! UIView
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
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     Get a snapshot (image representation) of this view.
     
     - returns: an Image snapshot.
     */
    public func snapshot() -> UIImage {
        return self.toImage()
    }
    
    /// Snapshot of view
    public var 📷: UIImage {
        return self.snapshot()
    }
}

public extension UIView {

    /// Get superview of sepcified type.
    ///
    /// - Parameter type: type to find.
    /// - Returns: superview of type specified or nil.
    public func superview<T: UIView>(ofType type: T.Type) -> T? {
        if let view = self.superview as? T {
            return view
        }
		return superview?.superview(ofType: type)
    }
    
    /**
     BFS search for first subview of type.
     
     - parameter type: type to find.
     
     - returns: subview of type specified or nil.
     */
    public func subviewOfType<T: UIView>(_ type: T.Type) -> T? {
        let queue = Queue<UIView>()
        for subview in self.subviews {
            queue.enqueue(subview)
        }
        
        while queue.isEmpty() == false {
            guard let current = queue.dequeue() else { continue }
            if let view = current as? T {
                return view
            } else {
                for subview in current.subviews {
                    queue.enqueue(subview)
                }
            }
        }
        
        return nil
    }
    
    /**
     BFS search for subviews of type.
     
     - parameter type: type to find.
     
     - returns: subviews of type specified or empty.
     */
    public func subviewsOfType<T: UIView>(_ type: T.Type) -> [T] {
        var views: [T] = []
        
        let queue = Queue<UIView>()
        for subview in self.subviews {
            queue.enqueue(subview)
        }
        
        while queue.isEmpty() == false {
            guard let current = queue.dequeue() else { continue }
            if let view = current as? T {
                views.append(view)
            } else {
                for subview in current.subviews {
                    queue.enqueue(subview)
                }
            }
        }
        
        return views
    }
}

// MARK: - View Ornaments
public extension UIView {
    /**
     Add dashed border line.
     
     - parameter borderWidth:            Border width.
     - parameter borderColor:            Border color.
     - parameter paintedSegmentLength:   Painted segment length.
     - parameter unpaintedSegmentLength: Unpainted segment length.
     */
    public func addDashedBorderLine(_ borderWidth: CGFloat, borderColor: UIColor, paintedSegmentLength: CGFloat = 2, unpaintedSegmentLength: CGFloat = 2) {
        layer.borderWidth = borderWidth
        let patternImage = UIImage.imageWithColor(.clear, size: CGSize(width: paintedSegmentLength + unpaintedSegmentLength, height: paintedSegmentLength + unpaintedSegmentLength))
            .fillRect(CGRect(x: 0, y: 0, width: paintedSegmentLength, height: paintedSegmentLength), withColor: borderColor)
            .fillRect(CGRect(x: unpaintedSegmentLength, y: unpaintedSegmentLength, width: paintedSegmentLength, height: paintedSegmentLength), withColor: borderColor)
        layer.borderColor = UIColor(patternImage: patternImage).cgColor
    }
    
    /**
     Add a dark shadow
     */
    public func addDarkShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 18.0
        // layer.shadowPath = UIBezierPath(rect: bounds).CGPath
    }
}
