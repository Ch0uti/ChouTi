//
//  UIViewController+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import UIKit

// MARK: - Storyboard
public extension UIViewController {
	
	/**
	Initialize a view controller in storyboard.
	
	:param: storyboardName     Storyboard name
	:param: viewControllerName Storyboard ID of the view controller
	
	:returns: An instance of view controller.
	*/
	class public func viewControllerInStoryboard(storyboardName: String , viewControllerName: String) -> UIViewController {
		let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
		let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName)
		return viewController
	}
}



// MARK: - Utility
public extension UIViewController {
	
	/**
	Check whether childViewControllers directly contain a view controller
	
	:param: childViewController View controller to be tested
	
	:returns: True if directly contained, false otherwise
	*/
	public func containChildViewController(childViewController: UIViewController) -> Bool {
		if #available(iOS 9.0, *) {
			return self.childViewControllers.contains(childViewController)
		} else {
			return self.childViewControllers.filter({$0 == childViewController}).count > 0
		}
	}
}



// MARK: - UI
public extension UIViewController {
	
	/**
	Create a left navigation bar backrgound view, this view will spans between leading and title's leading
	
	- returns: a newly created background view
	*/
	public func addLeftNavigationBarBackgroundView() -> UIView? {
		guard let navigationBar = navigationController?.navigationBar else {
			NSLog("navigationBar is nil")
			return nil
		}
		
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		navigationController?.navigationBar.addSubview(backgroundView)
		
		if #available(iOS 9.0, *) {
			backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.leadingAnchor).active = true
			
			if let titleView = navigationItem.titleView {
				backgroundView.trailingAnchor.constraintEqualToAnchor(titleView.leadingAnchor).active = true
			} else {
				backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
			}
			
			backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
			backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
		} else {
			NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: navigationBar, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			
			if let titleView = navigationItem.titleView {
				NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: titleView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			} else {
				NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
			}
			
			NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		}
		
		return backgroundView
	}
	
	/**
	Create a right navigation bar backrgound view, this view will spans between title's trailing and trailing
	
	- returns: a newly created background view
	*/
	public func addRightNavigationBarBackgroundView() -> UIView? {
		guard let navigationBar = navigationController?.navigationBar else {
			NSLog("navigationBar is nil")
			return nil
		}
		
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		navigationController?.navigationBar.addSubview(backgroundView)
		
		if #available(iOS 9.0, *) {
			backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.trailingAnchor).active = true
			
			if let titleView = navigationItem.titleView {
				backgroundView.leadingAnchor.constraintEqualToAnchor(titleView.trailingAnchor).active = true
			} else {
				backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
			}
			
			backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
			backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
		} else {
			NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: navigationBar, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
			
			if let titleView = navigationItem.titleView {
				NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: titleView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
			} else {
				NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
			}
			
			NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		}
		
		return backgroundView
	}
}



// MARK: - ViewController Appearance State Swizzling
extension UIViewController {
	// AppearanceState Associated Property
	enum AppearanceState {
		case WillAppear
		case WillDisappear
	}
	
	private struct AssociatedKeys {
		static var AppearanceStateKey = "zhh_AppearanceStateKey"
	}
	
	var isAppearing: Bool? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.AppearanceStateKey) as? Bool
		}
		
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.AppearanceStateKey, newValue as Bool? as? AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	// Swizzling beginAppearanceTransition/endAppearanceTransition
	public override class func initialize() {
		struct Static {
			static var beginAppearanceTransitionToken: dispatch_once_t = 0
			static var endAppearanceTransitionToken: dispatch_once_t = 0
		}
		
		// make sure this isn't a subclass
		if self !== UIViewController.self {
			return
		}
		
		dispatch_once(&Static.beginAppearanceTransitionToken) {
			let originalSelector = Selector("beginAppearanceTransition:animated:")
			let swizzledSelector = Selector("zhh_beginAppearanceTransition:animated:")
			
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			
			let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
			
			if didAddMethod {
				class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
			} else {
				method_exchangeImplementations(originalMethod, swizzledMethod);
			}
		}
		
		dispatch_once(&Static.endAppearanceTransitionToken) {
			let originalSelector = Selector("endAppearanceTransition")
			let swizzledSelector = Selector("zhh_endAppearanceTransition")
			
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
	
	func zhh_beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
		if self.isAppearing != isAppearing {
			self.zhh_beginAppearanceTransition(isAppearing, animated: animated)
			self.isAppearing = isAppearing
		}
	}
	
	func zhh_endAppearanceTransition() {
		if isAppearing != nil {
			self.zhh_endAppearanceTransition()
			self.isAppearing = nil
		}
	}
}
