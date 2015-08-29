//
//  UIViewController+Utility.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-08-11.
//
//

import UIKit

/// SlideController provides an interface of left/right panel layout
public class SlideController: UIViewController {
	/**
	The state of slide controller.
	
	- NotExpanded:   Showing center view controller
	- LeftExpanded:  Showing left view controller
	- RightExpanded: Showing right view controller
	*/
	public enum SlideState {
		case NotExpanded
		case LeftExpanded
		case RightExpanded
	}
	
	/// Center view controller
	public var centerViewController: UIViewController {
		willSet {
			removeViewController(centerViewController)
			centerViewController.view.removeGestureRecognizer(panGestureRecognizer)
		}
		
		didSet {
			addChildViewController(centerViewController)
			view.addSubview(centerViewController.view)
			centerViewController.didMoveToParentViewController(self)
			centerViewController.view.addGestureRecognizer(panGestureRecognizer)
		}
	}
	
	/// Left view controller
	public var leftViewController: UIViewController? {
		willSet {
			if newValue == nil {
				animateLeftViewController(shouldExpand: false, completion: { [unowned self] _ -> Void in
					self.removeViewController(self.leftViewController)
				})
			} else {
				removeViewController(leftViewController)
			}
		}
		
		didSet {
			if state == .LeftExpanded {
				addViewController(leftViewController)
			}
		}
	}
	/// Right view controller
	public var rightViewController: UIViewController? {
		willSet {
			if newValue == nil {
				animateRightViewController(shouldExpand: false, completion: { [unowned self] _ -> Void in
					self.removeViewController(self.rightViewController)
				})
			} else {
				removeViewController(rightViewController)
			}
		}
		
		didSet {
			if state == .RightExpanded {
				addViewController(rightViewController)
			}
		}
	}
	
	/// Current showing state of slide controller
	public var state: SlideState = .NotExpanded {
		didSet {
			showShadowForCenterViewController(state != .NotExpanded)
		}
	}
	
	/// Side view controller reveal width, by default, it's 3/4 of screen width
	public var revealWidth: CGFloat = 0.75 * UIScreen.mainScreen().bounds.width
	
	/// Reveal animation duration
	public var animationDuration: NSTimeInterval = 0.25
	
	/// Initial spring velocity of animation
	public var initialSpringVelocity: CGFloat = 0.0
	
	/// Spring dampin value of animation
	public var springDampin: CGFloat = 0.0
	
	private var leftViewControllerAdded: Bool = false
	private var rightViewControllerAdded: Bool = false
	
	private var panGestureRecognizer = UIPanGestureRecognizer()
	private var tapGestureRecognizer = UITapGestureRecognizer()
	
	/**
	Initialize a SlideController with center view controller. Left/Right controller is nil.
	
	:param: centerViewController The center view controller
	
	:returns: An initialized SlideController instance
	*/
	public convenience init(centerViewController: UIViewController) {
		self.init(centerViewController: centerViewController, leftViewController: nil, rightViewController: nil)
	}
	
	/**
	Initialize a SlideController with center, left and right view controller
	
	:param: centerViewController The center view controller
	:param: leftViewController   The left view controller
	:param: rightViewController  The right view controller
	
	:returns: An initialized SlideController instance
	*/
	public init(centerViewController: UIViewController, leftViewController: UIViewController?, rightViewController: UIViewController?) {
		self.centerViewController = centerViewController
		
		super.init(nibName: nil, bundle: nil)
		
		self.leftViewController = leftViewController
		self.rightViewController = rightViewController
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		panGestureRecognizer.addTarget(self, action: "handlePanGesture:")
		tapGestureRecognizer.addTarget(self, action: "handleTapGesture:")
		
		panGestureRecognizer.delegate = self
		tapGestureRecognizer.delegate = self
		
		addChildViewController(centerViewController)
		view.addSubview(centerViewController.view)
		centerViewController.didMoveToParentViewController(self)
		centerViewController.view.addGestureRecognizer(panGestureRecognizer)
		centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
	}
}

extension SlideController {
	/**
	Collapse slide controller, center view controller will be shown
	*/
	public func collapse() {
		switch state {
		case .LeftExpanded:
			animateLeftViewController(shouldExpand: false)
		case .RightExpanded:
			animateRightViewController(shouldExpand: false)
		default:
			return
		}
	}
	
	/**
	Toggle left view controller
	*/
	public func toggleLeftViewController() {
		if leftViewController == nil { return }
		let leftViewControllerIsAlreadyExpanded = (state == .LeftExpanded)
		if !leftViewControllerIsAlreadyExpanded {
			replaceViewController(rightViewController, withViewController: leftViewController)
			rightViewControllerAdded = false
			leftViewControllerAdded = true
		}
		
		animateLeftViewController(shouldExpand: !leftViewControllerIsAlreadyExpanded)
	}
	
	private func animateLeftViewController(#shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			state = .LeftExpanded
			animateCenterViewControllerWithXOffset(revealWidth, completion: { [unowned self] finished -> Void in
				self.leftViewController?.didMoveToParentViewController(self)
				completion?(finished)
			})
		} else {
			animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] finished -> Void in
				self.state = .NotExpanded
				self.removeViewController(self.leftViewController)
				self.leftViewControllerAdded = false
				completion?(finished)
			})
		}
	}
	
	/**
	Toggle right view controller
	*/
	public func toggleRightViewController() {
		if rightViewController == nil { return }
		let rightViewControllerIsAlreadyExpanded = (state == .RightExpanded)
		if !rightViewControllerIsAlreadyExpanded {
			replaceViewController(leftViewController, withViewController: rightViewController)
			leftViewControllerAdded = false
			rightViewControllerAdded = true
		}
		
		animateRightViewController(shouldExpand: !rightViewControllerIsAlreadyExpanded)
	}
	
	private func animateRightViewController(#shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			state = .RightExpanded
			animateCenterViewControllerWithXOffset(-revealWidth, completion: { [unowned self] finished -> Void in
				self.rightViewController?.didMoveToParentViewController(self)
				completion?(finished)
			})
		} else {
			animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] finished -> Void in
				self.state = .NotExpanded
				self.removeViewController(self.rightViewController)
				self.rightViewControllerAdded = false
				completion?(finished)
			})
		}
	}
	
	private func animateCenterViewController() {
		animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] _ -> Void in
			self.state = .NotExpanded
			self.removeViewController(self.leftViewController)
			self.leftViewControllerAdded = false
			self.removeViewController(self.rightViewController)
			self.rightViewControllerAdded = false
		})
	}
	
	private func animateCenterViewControllerWithXOffset(xOffset: CGFloat, completion: ((Bool) -> Void)? = nil) {
		let animationClosure: () -> Void = { [unowned self] in
			self.centerViewController.view.center = CGPoint(x: self.view.center.x + xOffset, y: self.view.center.y)
		}
		
		if springDampin == 0.0 && initialSpringVelocity == 0.0 {
			UIView.animateWithDuration(animationDuration, animations: animationClosure, completion: completion)
		} else {
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: springDampin, initialSpringVelocity: initialSpringVelocity, options: .BeginFromCurrentState | .CurveEaseInOut, animations: animationClosure, completion: completion)
		}
	}
	
	private func showShadowForCenterViewController(shouldShowShadow: Bool) {
		if shouldShowShadow {
			centerViewController.view.layer.shadowOpacity = 0.5
		} else {
			centerViewController.view.layer.shadowOpacity = 0.0
		}
	}
	
	private func replaceViewController(viewController: UIViewController?, withViewController: UIViewController?) {
		removeViewController(viewController)
		addViewController(withViewController)
	}
	
	private func addViewController(viewController: UIViewController?) {
		if let viewController = viewController {
			addChildViewController(viewController)
			view.insertSubview(viewController.view, belowSubview: centerViewController.view)
		}
	}
	
	private func removeViewController(viewController: UIViewController?) {
		if let viewController = viewController {
			viewController.willMoveToParentViewController(nil)
			viewController.view.removeFromSuperview()
			viewController.removeFromParentViewController()
		}
	}
}

extension SlideController: UIGestureRecognizerDelegate {
	func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			if state == .NotExpanded {
				showShadowForCenterViewController(true)
			}
		case .Changed:
			let centerX = view.bounds.width / 2.0
			if recognizer.view!.center.x > centerX {
				// Showing left
				if leftViewController == nil {
					recognizer.setTranslation(CGPointZero, inView: view)
					return
				}
				
				if !leftViewControllerAdded {
					replaceViewController(rightViewController, withViewController: leftViewController)
					rightViewControllerAdded = false
					leftViewControllerAdded = true
				}
			} else if recognizer.view!.center.x < centerX {
				// Showing right
				if rightViewController == nil {
					recognizer.setTranslation(CGPointZero, inView: view)
					return
				}
				if !rightViewControllerAdded {
					replaceViewController(leftViewController, withViewController: rightViewController)
					leftViewControllerAdded = false
					rightViewControllerAdded = true
				}
			}
			
			let resultCenterX = recognizer.view!.center.x + recognizer.translationInView(view).x
			// If resultCenterX is invalid, stop
			if (leftViewController == nil && resultCenterX >= centerX) || (rightViewController == nil && resultCenterX <= centerX) {
				recognizer.view!.center.x = centerX
				recognizer.setTranslation(CGPointZero, inView: view)
				return
			}
			
			recognizer.view!.center.x = resultCenterX
			recognizer.setTranslation(CGPointZero, inView: view)
		case .Ended:
			let velocity = recognizer.velocityInView(view)
			if velocity.x > 500.0 {
				// To right, fast enough
				if leftViewControllerAdded {
					animateLeftViewController(shouldExpand: true)
				} else {
					animateCenterViewController()
				}
			} else if velocity.x < -500.0 {
				// To left, fast enough
				if rightViewControllerAdded {
					animateRightViewController(shouldExpand: true)
				} else {
					animateCenterViewController()
				}
			} else {
				// Slow, check half position to determine whether show or not
				if recognizer.view!.center.x > view.bounds.width {
					// Showing left
					animateLeftViewController(shouldExpand: true)
				} else if recognizer.view!.center.x < 0 {
					// Showing right
					animateRightViewController(shouldExpand: true)
				} else {
					// Showing center
					animateCenterViewController()
				}
			}
		default:
			animateCenterViewController()
		}
	}
	
	func handleTapGesture(recognizer: UITapGestureRecognizer) {
		// Tap center view controller to collapse
		if state != .NotExpanded {
			animateCenterViewController()
		}
	}
}

extension SlideController: UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		// If one side view controller is nil, stop to reveal it
		if gestureRecognizer == panGestureRecognizer {
			if state == .NotExpanded {
				if panGestureRecognizer.velocityInView(view).x > 0 {
					return leftViewController != nil
				} else if panGestureRecognizer.velocityInView(view).x < 0 {
					return rightViewController != nil
				}
			}
		}
		
		return true
	}
}
