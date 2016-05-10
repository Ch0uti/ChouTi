//
//  UIView+OverlayView.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import UIKit

// MARK: - Overlay View
public extension UIView {
    
    private struct zhOverlayViewKey {
        static var Key = "zhOverlayViewKey"
    }
    
    private var zhOverlayView: UIView? {
        get { return objc_getAssociatedObject(self, &zhOverlayViewKey.Key) as? UIView }
        set { objc_setAssociatedObject(self, &zhOverlayViewKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func addOverlayView(animated animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.6),
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, overlayViewBackgroundColor: UIColor) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupOverlayView({ [unowned self] overlayView in
            self.addSubview(overlayView)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    public func insertOverlayViewBelowSubview(belowSubview: UIView,
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, overlayViewBackgroundColor: UIColor) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupOverlayView({ [unowned self] overlayView in
            self.insertSubview(overlayView, belowSubview: belowSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    public func insertOverlayViewAboveSubview(aboveSubview: UIView,
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, overlayViewBackgroundColor: UIColor) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupOverlayView({ [unowned self] overlayView in
            self.insertSubview(overlayView, aboveSubview: aboveSubview)
            }, animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    private func _setupOverlayView(viewConfiguration: (UIView -> Void),
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, overlayViewBackgroundColor: UIColor) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = overlayViewBackgroundColor
        
        if viewKeyPointer != nil {
            if getAssociatedViewForKeyPointer(viewKeyPointer) != nil {
                print("Warning: found existing overlay view with viewKeyPointer: \(viewKeyPointer)")
            }
            
            setAssociatedView(overlayView, forKeyPointer: viewKeyPointer)
        } else {
            if zhOverlayView != nil {
                print("Warning: found existing overlay view")
            }
            
            // Let self keep the reference to the view, used for retriving the overlay view
            zhOverlayView = overlayView
        }
        
        if !animated {
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, overlayViewBackgroundColor: overlayViewBackgroundColor)
            completion?(overlayView: overlayView)
        } else {
            overlayView.alpha = 0.0
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, overlayViewBackgroundColor: overlayViewBackgroundColor)
            
            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.CurveEaseInOut, .BeginFromCurrentState] , animations: {
                overlayView.alpha = 1.0
                }) { (finished) -> Void in
                    completion?(overlayView: overlayView)
            }
        }
        
        return overlayView
    }
    
    public func removeOverlayView(animated animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat) -> ())? = nil,
        completion: ((Bool) -> ())? = nil)
    {
        let overlayView: UIView
        if viewKeyPointer != nil {
            guard let theOverlayView = getAssociatedViewForKeyPointer(viewKeyPointer) else {
                print("Error: overlay view is not existed")
                beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        } else {
            guard let theOverlayView = zhOverlayView else {
                print("Error: overlay view is not existed")
                beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        }
        
        if !animated {
            overlayView.removeFromSuperview()
            if viewKeyPointer != nil {
                clearAssociatedViewForKeyPointer(viewKeyPointer)
            } else {
                zhOverlayView = nil
            }
            
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
            completion?(true)
        } else {
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: {
                overlayView.alpha = 0.0
            }) { [unowned self] (finished) -> Void in
                overlayView.removeFromSuperview()
                if viewKeyPointer != nil {
                    self.clearAssociatedViewForKeyPointer(viewKeyPointer)
                } else {
                    self.zhOverlayView = nil
                }
                completion?(finished)
            }
        }
    }
    
    // MARK: - Blurred Overlay View
    private struct zhBlurredOverlayViewKey {
        static var Key = "zhBlurredOverlayViewKey"
    }
    
    private var zhBlurredOverlayView: UIView? {
        get { return objc_getAssociatedObject(self, &zhBlurredOverlayViewKey.Key) as? UIView }
        set { objc_setAssociatedObject(self, &zhBlurredOverlayViewKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func addBlurredOverlayView(animated animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffectStyle = .Dark,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, blurredViewBackgroundColor: UIColor, blurEffectStyle: UIBlurEffectStyle) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupBlurredOverlayView({ [unowned self] overlayView in
            self.addSubview(overlayView)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    public func insertBlurredOverlayViewBelowSubview(belowSubview: UIView,
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffectStyle = .Dark,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, blurredViewBackgroundColor: UIColor, blurEffectStyle: UIBlurEffectStyle) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupBlurredOverlayView({ [unowned self] overlayView in
            self.insertSubview(overlayView, belowSubview: belowSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    public func insertBlurredOverlayViewAboveSubview(aboveSubview: UIView,
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffectStyle = .Dark,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, blurredViewBackgroundColor: UIColor, blurEffectStyle: UIBlurEffectStyle) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        return _setupBlurredOverlayView({ [unowned self] overlayView in
            self.insertSubview(overlayView, aboveSubview: aboveSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }
    
    private func _setupBlurredOverlayView(viewConfiguration: (UIView -> Void),
        animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffectStyle = .Dark,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat, blurredViewBackgroundColor: UIColor, blurEffectStyle: UIBlurEffectStyle) -> ())? = nil,
        completion: ((overlayView: UIView) -> ())? = nil) -> UIView
    {
        
        if zhBlurredOverlayView != nil {
            print("warning: found existing blurred overlay view")
        }
        
        let overlayView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = blurredViewBackgroundColor
        
        if viewKeyPointer != nil {
            if getAssociatedViewForKeyPointer(viewKeyPointer) != nil {
                print("Warning: found existing blurred overlay view with viewKeyPointer: \(viewKeyPointer)")
            }
            
            setAssociatedView(overlayView, forKeyPointer: viewKeyPointer)
        } else {
            if zhBlurredOverlayView != nil {
                print("warning: found existing blurred overlay view")
            }
            
            // Let self keep the reference to the view, used for retriving the overlay view
            zhBlurredOverlayView = overlayView
        }
        
        if !animated {
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, blurredViewBackgroundColor: blurredViewBackgroundColor, blurEffectStyle: blurEffectStyle)
            completion?(overlayView: overlayView)
        } else {
            overlayView.alpha = 0.0
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, blurredViewBackgroundColor: blurredViewBackgroundColor, blurEffectStyle: blurEffectStyle)
            completion?(overlayView: overlayView)
            
            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.CurveEaseInOut, .BeginFromCurrentState] , animations: {
                overlayView.alpha = 1.0
            }) { (finished) -> Void in
                completion?(overlayView: overlayView)
            }
        }
        
        return overlayView
    }
    
    public func removeBlurredOverlayView(animated animated: Bool = true,
        duration: NSTimeInterval = 0.5,
        delay: NSTimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        viewKeyPointer: UnsafePointer<String> = nil,
        beginning: ((animated: Bool, duration: NSTimeInterval, delay: NSTimeInterval, dampingRatio: CGFloat, velocity: CGFloat) -> ())? = nil,
        completion: ((Bool) -> ())? = nil)
    {
        
        let overlayView: UIView
        if viewKeyPointer != nil {
            guard let theOverlayView = getAssociatedViewForKeyPointer(viewKeyPointer) else {
                print("Error: blurred overlay view is not existed")
                beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        } else {
            guard let theOverlayView = zhBlurredOverlayView else {
                print("Error: blurred overlay view is not existed")
                beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        }
        
        if !animated {
            overlayView.removeFromSuperview()
            if viewKeyPointer != nil {
                clearAssociatedViewForKeyPointer(viewKeyPointer)
            } else {
                zhBlurredOverlayView = nil
            }
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
            completion?(true)
        } else {
            beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity)
            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: {
                overlayView.alpha = 0.0
            }) { [unowned self] (finished) -> Void in
                overlayView.removeFromSuperview()
                if viewKeyPointer != nil {
                    self.clearAssociatedViewForKeyPointer(viewKeyPointer)
                } else {
                    self.zhBlurredOverlayView = nil
                }
                completion?(finished)
            }
        }
    }
    
    // MARK: - Helper Methos
    private func setAssociatedView(view: UIView, forKeyPointer keyPointer: UnsafePointer<String>) -> UIView? {
        let associatedView = getAssociatedViewForKeyPointer(keyPointer)
        objc_setAssociatedObject(self, keyPointer, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associatedView
    }
    
    private func getAssociatedViewForKeyPointer(keyPointer: UnsafePointer<String>) -> UIView? {
        return objc_getAssociatedObject(self, keyPointer) as? UIView
    }
    
    private func clearAssociatedViewForKeyPointer(keyPointer: UnsafePointer<String>) -> UIView?  {
        let associatedView = getAssociatedViewForKeyPointer(keyPointer)
        objc_setAssociatedObject(self, keyPointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associatedView
    }
}
