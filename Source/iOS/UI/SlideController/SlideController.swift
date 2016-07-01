//
//  UIViewController+Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
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
		case LeftExpanding
		case LeftExpanded
		case LeftCollapsing
		case RightExpanding
		case RightExpanded
		case RightCollapsing
	}
	
	// TODO: Handling rotations
	
	/// Center view controller
	public var centerViewController: UIViewController {
		willSet {
			beginViewController(centerViewController, appearanceTransition: false, animated: false)
			removeViewController(centerViewController)
			endViewControllerAppearanceTransition(centerViewController)
			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.removeGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.removeGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.removeGestureRecognizer(panGestureRecognizer)
			}
			centerViewController.view.removeGestureRecognizer(tapGestureRecognizer)
		}
		
		didSet {
			beginViewController(centerViewController, appearanceTransition: true, animated: false)
			addChildViewController(centerViewController)
			
			// Make sure newly added center view is below status bar
			view.insertSubview(centerViewController.view, belowSubview: statusBarBackgroundView)
			
			// New view controller should have a same frame as before
			switch state {
			case .LeftExpanding, .LeftExpanded, .LeftCollapsing:
				animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .RightExpanding, .RightExpanded, .RightCollapsing:
				animateCenterViewControllerWithXOffset(rightRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .NotExpanded:
				animateCenterViewControllerWithXOffset(0, animated: false, completion: nil)
			}
			
			// Make sure left/right view is below center view
			if let leftView = leftViewController?.view {
				view.insertSubview(leftView, belowSubview: centerViewController.view)
			}
			if let rightView = rightViewController?.view {
				view.insertSubview(rightView, belowSubview: centerViewController.view)
			}
			
			centerViewController.didMoveToParentViewController(self)
			endViewControllerAppearanceTransition(centerViewController)
			
			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.addGestureRecognizer(panGestureRecognizer)
			}
			centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
		}
	}
	
	/// Left view controller
	public var leftViewController: UIViewController? {
		willSet {
			switch state {
			case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
				beginViewController(leftViewController, appearanceTransition: false, animated: newValue == nil)
				previousLeftViewController = leftViewController
			default:
				break
			}
			
			if newValue == nil {
				animateLeftViewControllerShouldExpand(false, completion: { [unowned self] _ in
					if let leftViewController = self.previousLeftViewController {
						self.removeViewController(leftViewController)
						switch self.state {
						case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
							self.endViewControllerAppearanceTransition(leftViewController)
						default:
							break
						}
						
						self.previousLeftViewController = nil
					}
				})
			} else {
				if let leftViewController = self.leftViewController {
					removeViewController(leftViewController)
					endViewControllerAppearanceTransition(leftViewController)
				}
				
				previousLeftViewController = nil
			}
		}
		
		didSet {
			if state == .LeftExpanded {
				beginViewController(leftViewController, appearanceTransition: true, animated: false)
				addViewController(leftViewController!)
				endViewControllerAppearanceTransition(leftViewController)
			}
		}
	}
	
	private var previousLeftViewController: UIViewController?
	
	/// Right view controller
	public var rightViewController: UIViewController? {
		willSet {
			switch state {
			case .RightExpanded, .RightExpanding, .RightCollapsing:
				beginViewController(rightViewController, appearanceTransition: false, animated: newValue == nil)
				previousRightViewController = rightViewController
			default:
				break
			}
			
			if newValue == nil {
				animateRightViewControllerShouldExpand(false, completion: { [unowned self] _ in
					if let rightViewController = self.previousRightViewController {
						self.removeViewController(rightViewController)
						switch self.state {
						case .RightExpanded, .RightExpanding, .RightCollapsing:
							self.endViewControllerAppearanceTransition(rightViewController)
						default:
							break
						}
						
						self.previousRightViewController = nil
					}
				})
			} else {
				if let rightViewController = self.rightViewController {
					removeViewController(rightViewController)
					endViewControllerAppearanceTransition(rightViewController)
				}
				
				previousRightViewController = nil
			}
		}
		
		didSet {
			if state == .RightExpanded {
				beginViewController(rightViewController, appearanceTransition: true, animated: false)
				addViewController(rightViewController!)
				endViewControllerAppearanceTransition(rightViewController)
			}
		}
	}
	
	private var previousRightViewController: UIViewController?
	
	/// Current showing state of slide controller
	public var state: SlideState = .NotExpanded {
		didSet {
			showShadowForCenterViewController(state != .NotExpanded)
		}
	}
	
	/// Side view controller reveal width, by default, it's 3/4 of screen width
	public var revealWidth: CGFloat = 0.75 * UIScreen.mainScreen().bounds.width
	public var leftRevealWidth: CGFloat?
	public var rightRevealWidth: CGFloat?
	
	public var shouldExceedRevealWidth: Bool = true
	
	/// Reveal animation duration
	public var animationDuration: NSTimeInterval = 0.25
	private var animated: Bool { return animationDuration > 0.0 }
	
	/// Initial spring velocity of animation
	public var initialSpringVelocity: CGFloat?
	
	/// Spring dampin value of animation
	public var springDampin: CGFloat?
	
	private var leftViewControllerAdded: Bool = false
	private var rightViewControllerAdded: Bool = false
	
	private var isVisible: Bool { return isViewLoaded() && (view.window != nil) }
	private var isAnimating: Bool = false
	
	/// Whether should use screen edge pan gesture
	public var useScreenEdgePanGestureRecognizer: Bool = true {
		didSet {
			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.removeGestureRecognizer(panGestureRecognizer)
				centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.removeGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.removeGestureRecognizer(rightEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(panGestureRecognizer)
			}
		}
	}
	
	private let panGestureRecognizer = UIPanGestureRecognizer()
	private let leftEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	private let rightEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	private let tapGestureRecognizer = UITapGestureRecognizer()
	
	/// Status bar color when expanded, set nil to clear status bar background color
	public var statusBarBackgroundColor: UIColor? = nil {
		didSet {
			if statusBarBackgroundColor == nil {
				statusBarBackgroundView.removeFromSuperview()
			} else {
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor
				view.addSubview(statusBarBackgroundView)
			}
		}
	}
	
	private lazy var statusBarBackgroundView: UIView = {
		return UIView(frame: UIApplication.sharedApplication().statusBarFrame)
	}()
	
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

	required public init?(coder aDecoder: NSCoder) {
		self.centerViewController = UIViewController()
	    super.init(coder: aDecoder)
	}
	
	public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
		return false
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		switch state {
		case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
			leftViewController?.beginAppearanceTransition(true, animated: animated)
		case .RightExpanded, .RightExpanding, .RightCollapsing:
			rightViewController?.beginAppearanceTransition(true, animated: animated)
		case .NotExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(true, animated: animated)
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		switch state {
		case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .RightExpanded, .RightExpanding, .RightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .NotExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}
	
	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		super.viewWillAppear(animated)
		switch state {
		case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
			leftViewController?.beginAppearanceTransition(false, animated: animated)
		case .RightExpanded, .RightExpanding, .RightCollapsing:
			rightViewController?.beginAppearanceTransition(false, animated: animated)
		case .NotExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(false, animated: animated)
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		switch state {
		case .LeftExpanded, .LeftExpanding, .LeftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .RightExpanded, .RightExpanding, .RightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .NotExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		panGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.edges = .Left
		leftEdgePanGestureRecognizer.cancelsTouchesInView = false
		rightEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		rightEdgePanGestureRecognizer.edges = .Right
		rightEdgePanGestureRecognizer.cancelsTouchesInView = false
		tapGestureRecognizer.addTarget(self, action: #selector(SlideController.handleTapGesture(_:)))
		tapGestureRecognizer.cancelsTouchesInView = false
		
		panGestureRecognizer.delegate = self
		leftEdgePanGestureRecognizer.delegate = self
		rightEdgePanGestureRecognizer.delegate = self
		tapGestureRecognizer.delegate = self
		
		addChildViewController(centerViewController)
		view.addSubview(centerViewController.view)
		centerViewController.didMoveToParentViewController(self)
		
		if useScreenEdgePanGestureRecognizer {
			centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
			centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
		} else {
			centerViewController.view.addGestureRecognizer(panGestureRecognizer)
		}
		centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
		
		if statusBarBackgroundColor != nil {
			statusBarBackgroundView.backgroundColor = statusBarBackgroundColor!.colorWithAlphaComponent(0.0)
			view.addSubview(statusBarBackgroundView)
		}
	}
}

extension SlideController {
	/**
	Collapse slide controller, center view controller will be shown
	*/
	public func collapse() {
		switch state {
		case .LeftExpanded:
			toggleLeftViewController()
		case .RightExpanded:
			toggleRightViewController()
		default:
			return
		}
	}
	
	/**
	Toggle left view controller
	*/
	public func toggleLeftViewController() {
		if leftViewController == nil { return }
		if isAnimating { return }
		let leftViewControllerShouldExapnd = (state != .LeftExpanded)
		if leftViewControllerShouldExapnd {
			beginViewController(leftViewController, appearanceTransition: true, animated: animated)
			beginViewController(centerViewController, appearanceTransition: false, animated: animated)
		} else {
			beginViewController(leftViewController, appearanceTransition: false, animated: animated)
			beginViewController(centerViewController, appearanceTransition: true, animated: animated)
		}
		
		animateLeftViewControllerShouldExpand(leftViewControllerShouldExapnd) { [unowned self] _ in
			self.endViewControllerAppearanceTransition(self.leftViewController)
			self.endViewControllerAppearanceTransition(self.centerViewController)
			self.isAnimating = false
		}
	}
	
	private func animateLeftViewControllerShouldExpand(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			replaceViewController(rightViewController, withViewController: leftViewController)
			rightViewControllerAdded = false
			leftViewControllerAdded = true
			
			state = .LeftExpanding
			animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, completion: { [unowned self] finished -> Void in
				self.leftViewController?.didMoveToParentViewController(self)
				self.state = .LeftExpanded
				completion?(finished)
			})
		} else {
			state = .LeftCollapsing
			animateCenterViewController({ finished in
				completion?(finished)
			})
		}
	}
	
	/**
	Toggle right view controller
	*/
	public func toggleRightViewController() {
		if rightViewController == nil { return }
		if isAnimating { return }
		let rightViewControllerShouldExapnd = (state != .RightExpanded)
		if rightViewControllerShouldExapnd {
			beginViewController(rightViewController, appearanceTransition: true, animated: animated)
			beginViewController(centerViewController, appearanceTransition: false, animated: animated)
		} else {
			beginViewController(rightViewController, appearanceTransition: false, animated: animated)
			beginViewController(centerViewController, appearanceTransition: true, animated: animated)
		}
		
		animateRightViewControllerShouldExpand(rightViewControllerShouldExapnd) { [unowned self] _ in
			self.endViewControllerAppearanceTransition(self.rightViewController)
			self.endViewControllerAppearanceTransition(self.centerViewController)
		}
	}
	
	private func animateRightViewControllerShouldExpand(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			replaceViewController(leftViewController, withViewController: rightViewController)
			leftViewControllerAdded = false
			rightViewControllerAdded = true
			
			state = .RightExpanding
			animateCenterViewControllerWithXOffset(-(rightRevealWidth ?? revealWidth), completion: { [unowned self] finished -> Void in
				self.rightViewController?.didMoveToParentViewController(self)
				self.state = .RightExpanded
				completion?(finished)
			})
		} else {
			state = .RightCollapsing
			animateCenterViewController({ finished in
				completion?(finished)
			})
		}
	}
	
	/**
	Go to state .NotExpanded
	*/
	private func animateCenterViewController(completion: ((Bool) -> Void)? = nil) {
		animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] finished -> Void in
			switch self.state {
			case .LeftExpanding, .LeftExpanded:
				self.removeViewController(self.leftViewController!)
				self.leftViewControllerAdded = false
			case .RightExpanding, .RightExpanded:
				self.removeViewController(self.rightViewController!)
				self.rightViewControllerAdded = false
			default:
				break
			}
			completion?(finished)
			self.state = .NotExpanded
		})
	}
	
	private func animateCenterViewControllerWithXOffset(xOffset: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
		let animationClosure: () -> Void = { [unowned self] in
			self.centerViewController.view.center = CGPoint(x: self.view.center.x + xOffset, y: self.centerViewController.view.center.y)
			self.centerViewController.view.frame.origin.y = 0
			self.statusBarBackgroundView.backgroundColor = self.statusBarBackgroundColor?.colorWithAlphaComponent(abs(xOffset) / (xOffset > 0 ? (self.leftRevealWidth ?? self.revealWidth) : (self.rightRevealWidth ?? self.revealWidth)))
			self.isAnimating = false
		}
		
		if !animated {
			animationClosure()
			completion?(true)
			return
		}
		
		if let springDampin = springDampin, initialSpringVelocity = initialSpringVelocity where shouldExceedRevealWidth == true {
			isAnimating = true
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: springDampin, initialSpringVelocity: initialSpringVelocity, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: animationClosure, completion: completion)
		} else {
			isAnimating = true
			UIView.animateWithDuration(animationDuration, animations: animationClosure, completion: completion)
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
		if let viewController = viewController where containChildViewController(viewController) {
			removeViewController(viewController)
		}
		
		if let withViewController = withViewController where !containChildViewController(withViewController) {
			addViewController(withViewController)
		}
	}
	
	private func removeViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	private func addViewController(viewController: UIViewController) {
		addChildViewController(viewController)
		view.insertSubview(viewController.view, belowSubview: centerViewController.view)
	}
}

extension SlideController: UIGestureRecognizerDelegate {
	func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			switch state {
			case .NotExpanded:
				// If going to expand
				showShadowForCenterViewController(true)
				let velocity = recognizer.velocityInView(view)
				if velocity.x > 0 && leftViewController != nil {
					// Show left
					beginViewController(leftViewController, appearanceTransition: true, animated: true)
					state = .LeftExpanding
					beginViewController(centerViewController, appearanceTransition: false, animated: true)
				} else if velocity.x < 0 && rightViewController != nil {
					// Show right
					beginViewController(rightViewController, appearanceTransition: true, animated: true)
					state = .RightExpanding
					beginViewController(centerViewController, appearanceTransition: false, animated: true)
				}
				
			case .LeftExpanded:
				// If going to collapse from left
				beginViewController(leftViewController, appearanceTransition: false, animated: true)
				state = .LeftCollapsing
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			case .RightExpanded:
				// If going to collapse from right
				beginViewController(rightViewController, appearanceTransition: false, animated: true)
				state = .RightCollapsing
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			default:
				assertionFailure()
			}
		case .Changed:
			let centerX = view.bounds.width / 2.0
			let centerXToBe = recognizer.view!.center.x + recognizer.translationInView(view).x
			
			if recognizer.view!.center.x > centerX {
				// Showing left
				
				// If there's no left view controller, no need for vc configuration
				if leftViewController == nil {
					recognizer.setTranslation(CGPointZero, inView: view)
					return
				}
				
				if !leftViewControllerAdded {
					replaceViewController(rightViewController, withViewController: leftViewController)
					rightViewControllerAdded = false
					leftViewControllerAdded = true
				}
				
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.colorWithAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (leftRevealWidth ?? revealWidth), 1.0))
				
				// If revealed width is greater than reveal width set, stop it
				if shouldExceedRevealWidth == false && (centerXToBe - centerX >= leftRevealWidth ?? revealWidth){
					recognizer.view!.center.x = centerX + (leftRevealWidth ?? revealWidth)
					recognizer.setTranslation(CGPointZero, inView: view)
					return
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
				
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.colorWithAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (rightRevealWidth ?? revealWidth), 1.0))
				
				if shouldExceedRevealWidth == false && (centerX - centerXToBe >= rightRevealWidth ?? revealWidth){
					recognizer.view!.center.x = centerX - (rightRevealWidth ?? revealWidth)
					recognizer.setTranslation(CGPointZero, inView: view)
					return
				}
			}
			
			// If resultCenterX is invalid, stop
			if (leftViewController == nil && centerXToBe >= centerX) || (rightViewController == nil && centerXToBe <= centerX) {
				recognizer.view!.center.x = centerX
				recognizer.setTranslation(CGPointZero, inView: view)
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.colorWithAlphaComponent(0)
				return
			}
			
			recognizer.view!.center.x = centerXToBe
			recognizer.setTranslation(CGPointZero, inView: view)
		case .Ended:
			let velocity = recognizer.velocityInView(view)
			if velocity.x > 500.0 {
				// To right, fast enough
				if leftViewControllerAdded {
					animateLeftViewControllerShouldExpand(true) { [unowned self] _ in
						self.endViewControllerAppearanceTransition(self.leftViewController)
						self.endViewControllerAppearanceTransition(self.centerViewController)
					}
				} else {
					fallthrough
				}
			} else if velocity.x < -500.0 {
				// To left, fast enough
				if rightViewControllerAdded {
					animateRightViewControllerShouldExpand(true) { [unowned self] _ in
						self.endViewControllerAppearanceTransition(self.rightViewController)
						self.endViewControllerAppearanceTransition(self.centerViewController)
					}
				} else {
					fallthrough
				}
			} else {
				// Slow, check half position to determine whether show or not
				if recognizer.view!.center.x > view.bounds.width {
					// Showing left
					switch state {
					case .LeftCollapsing:
						beginViewController(leftViewController, appearanceTransition: true, animated: true)
						beginViewController(centerViewController, appearanceTransition: false, animated: true)
					default:
						break
					}
					animateLeftViewControllerShouldExpand(true) { [unowned self] _ in
						self.endViewControllerAppearanceTransition(self.leftViewController)
						self.endViewControllerAppearanceTransition(self.centerViewController)
					}
				} else if recognizer.view!.center.x < 0 {
					// Showing right
					switch state {
					case .RightCollapsing:
						beginViewController(rightViewController, appearanceTransition: true, animated: true)
						beginViewController(centerViewController, appearanceTransition: false, animated: true)
					default:
						break
					}
					animateRightViewControllerShouldExpand(true) { [unowned self] _ in
						self.endViewControllerAppearanceTransition(self.rightViewController)
						self.endViewControllerAppearanceTransition(self.centerViewController)
					}
				} else {
					// Showing center
					fallthrough
				}
			}
		default:
			switch state {
			case .LeftExpanding:
				beginViewController(leftViewController, appearanceTransition: false, animated: true)
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			case .RightExpanding:
				beginViewController(rightViewController, appearanceTransition: false, animated: true)
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			default:
				break
			}
			
			animateCenterViewController({ [unowned self] _ in
				switch self.state {
				case .LeftExpanding, .LeftCollapsing:
					self.endViewControllerAppearanceTransition(self.leftViewController)
					self.endViewControllerAppearanceTransition(self.centerViewController)
				case .RightExpanding, .RightCollapsing:
					self.endViewControllerAppearanceTransition(self.rightViewController)
					self.endViewControllerAppearanceTransition(self.centerViewController)
				default:
					break
				}
			})
		}
	}
	
	func handleTapGesture(recognizer: UITapGestureRecognizer) {
		// Tap center view controller to collapse
		if state != .NotExpanded {
			collapse()
		}
	}
}

extension SlideController {
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

extension SlideController {
	private func beginViewController(viewController: UIViewController?, appearanceTransition isAppearing: Bool, animated: Bool) {
		if isVisible {
			viewController?.beginAppearanceTransition(isAppearing, animated: animated)
		}
	}
	
	private func endViewControllerAppearanceTransition(viewController: UIViewController?) {
		if isVisible {
			viewController?.endAppearanceTransition()
		}
	}
}
