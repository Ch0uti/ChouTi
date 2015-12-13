//
//  UIView+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//

import UIKit

public extension UIView {

	/**
	Directy contaitns a view, not recursively
	
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

public extension UIView {
	public func frameRectInView(view: UIView?) -> CGRect {
		return self.convertRect(self.bounds, toView: view)
	}
}

// MARK: - Auto Layout
public extension UIView {
	
	public func fullSizeInSuperview() -> [NSLayoutConstraint] {
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
	
	public func fullSizeMarginInSuperview() -> [NSLayoutConstraint] {
		guard let superview = self.superview else {
			fatalError("superview is nil")
		}
		
		translatesAutoresizingMaskIntoConstraints = false
		var constraints = [NSLayoutConstraint]()
		
		constraints += [
			NSLayoutConstraint(item: self, attribute: .TopMargin, relatedBy: .Equal, toItem: superview, attribute: .TopMargin, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: self, attribute: .LeadingMargin, relatedBy: .Equal, toItem: superview, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: self, attribute: .BottomMargin, relatedBy: .Equal, toItem: superview, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: self, attribute: .TrailingMargin, relatedBy: .Equal, toItem: superview, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0)
		]
		
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

public extension UIView {
	public var isVisible: Bool { return (window != nil) }
}

public extension UIView {
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

public extension UIView {
	// MARK: - Overlay View
	
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
			overlayView.fullSizeInSuperview()
			beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, overlayViewBackgroundColor: overlayViewBackgroundColor)
			completion?(overlayView: overlayView)
		} else {
			overlayView.alpha = 0.0
			viewConfiguration(overlayView)
			overlayView.fullSizeInSuperview()
			
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
			overlayView.fullSizeInSuperview()
			beginning?(animated: animated, duration: duration, delay: delay, dampingRatio: dampingRatio, velocity: velocity, blurredViewBackgroundColor: blurredViewBackgroundColor, blurEffectStyle: blurEffectStyle)
			completion?(overlayView: overlayView)
		} else {
			overlayView.alpha = 0.0
			viewConfiguration(overlayView)
			overlayView.fullSizeInSuperview()
			
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
	private func setAssociatedView(view: UIView, forKeyPointer keyPointer: UnsafePointer<String>) {
		objc_setAssociatedObject(self, keyPointer, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
	
	private func getAssociatedViewForKeyPointer(keyPointer: UnsafePointer<String>) -> UIView? {
		return objc_getAssociatedObject(self, keyPointer) as? UIView
	}
	
	private func clearAssociatedViewForKeyPointer(keyPointer: UnsafePointer<String>) {
		objc_setAssociatedObject(self, keyPointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
				method_exchangeImplementations(originalMethod, swizzledMethod);
			}
		}
	}
	
	func zhh_addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
		self.zhh_addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.attachedView = self
		
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
	public func firstRespondedViewController() -> UIViewController? {
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
	public func switchBackgroundColorWithAnotherView(anotherView: UIView) {
		let anotherViewBackgroundColor = anotherView.backgroundColor
		anotherView.backgroundColor = backgroundColor
		backgroundColor = anotherViewBackgroundColor
	}
}

public extension UIView {
	public var width: CGFloat {
		return bounds.width
	}
	
	public var height: CGFloat {
		return bounds.height
	}
}
