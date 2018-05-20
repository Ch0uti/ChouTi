//
//  UIViewController+Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

/// SlideController provides an interface of left/right panel layout
open class SlideController: UIViewController {
	/**
	The state of slide controller.
	
	- NotExpanded:   Showing center view controller
	- LeftExpanded:  Showing left view controller
	- RightExpanded: Showing right view controller
	*/
	public enum SlideState {
		case notExpanded
		case leftExpanding
		case leftExpanded
		case leftCollapsing
		case rightExpanding
		case rightExpanded
		case rightCollapsing
	}
	
	// TODO: Handling rotations
	
	/// Center view controller
	open var centerViewController: UIViewController {
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
			case .leftExpanding, .leftExpanded, .leftCollapsing:
				animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .rightExpanding, .rightExpanded, .rightCollapsing:
				animateCenterViewControllerWithXOffset(rightRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .notExpanded:
				animateCenterViewControllerWithXOffset(0, animated: false, completion: nil)
			}
			
			// Make sure left/right view is below center view
			if let leftView = leftViewController?.view {
				view.insertSubview(leftView, belowSubview: centerViewController.view)
			}
			if let rightView = rightViewController?.view {
				view.insertSubview(rightView, belowSubview: centerViewController.view)
			}
			
			centerViewController.didMove(toParentViewController: self)
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
	open var leftViewController: UIViewController? {
		willSet {
			switch state {
			case .leftExpanded, .leftExpanding, .leftCollapsing:
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
						case .leftExpanded, .leftExpanding, .leftCollapsing:
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
			if state == .leftExpanded {
				beginViewController(leftViewController, appearanceTransition: true, animated: false)
				addViewController(leftViewController!)
				endViewControllerAppearanceTransition(leftViewController)
			}
		}
	}
	
	fileprivate var previousLeftViewController: UIViewController?
	
	/// Right view controller
	open var rightViewController: UIViewController? {
		willSet {
			switch state {
			case .rightExpanded, .rightExpanding, .rightCollapsing:
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
						case .rightExpanded, .rightExpanding, .rightCollapsing:
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
			if state == .rightExpanded {
				beginViewController(rightViewController, appearanceTransition: true, animated: false)
				addViewController(rightViewController!)
				endViewControllerAppearanceTransition(rightViewController)
			}
		}
	}
	
	fileprivate var previousRightViewController: UIViewController?
	
	/// Current showing state of slide controller
	open var state: SlideState = .notExpanded {
		didSet {
			showShadowForCenterViewController(state != .notExpanded)
		}
	}
	
	/// Side view controller reveal width, by default, it's 3/4 of screen width
	open var revealWidth: CGFloat = 0.75 * UIScreen.main.bounds.width
	open var leftRevealWidth: CGFloat?
	open var rightRevealWidth: CGFloat?
	
	open var shouldExceedRevealWidth: Bool = true
	
	/// Reveal animation duration
	open var animationDuration: TimeInterval = 0.25
	fileprivate var animated: Bool { return animationDuration > 0.0 }
	
	/// Initial spring velocity of animation
	open var initialSpringVelocity: CGFloat?
	
	/// Spring dampin value of animation
	open var springDampin: CGFloat?
	
	fileprivate var leftViewControllerAdded: Bool = false
	fileprivate var rightViewControllerAdded: Bool = false
	
	fileprivate var isVisible: Bool { return isViewLoaded && (view.window != nil) }
	fileprivate var isAnimating: Bool = false
	
	/// Whether should use screen edge pan gesture
	open var useScreenEdgePanGestureRecognizer: Bool = true {
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
	
	fileprivate let panGestureRecognizer = UIPanGestureRecognizer()
	fileprivate let leftEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	fileprivate let rightEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	fileprivate let tapGestureRecognizer = UITapGestureRecognizer()
	
	/// Status bar color when expanded, set nil to clear status bar background color
	open var statusBarBackgroundColor: UIColor? = nil {
		didSet {
			if statusBarBackgroundColor == nil {
				statusBarBackgroundView.removeFromSuperview()
			} else {
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor
				view.addSubview(statusBarBackgroundView)
			}
		}
	}
	
	fileprivate lazy var statusBarBackgroundView: UIView = {
		return UIView(frame: UIApplication.shared.statusBarFrame)
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
	
	open override var shouldAutomaticallyForwardAppearanceMethods : Bool {
		return false
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.beginAppearanceTransition(true, animated: animated)
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.beginAppearanceTransition(true, animated: animated)
		case .notExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(true, animated: animated)
	}
	
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .notExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		super.viewWillAppear(animated)
		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.beginAppearanceTransition(false, animated: animated)
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.beginAppearanceTransition(false, animated: animated)
		case .notExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(false, animated: animated)
	}
	
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .notExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		
		panGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.edges = .left
		leftEdgePanGestureRecognizer.cancelsTouchesInView = false
		rightEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		rightEdgePanGestureRecognizer.edges = .right
		rightEdgePanGestureRecognizer.cancelsTouchesInView = false
		tapGestureRecognizer.addTarget(self, action: #selector(SlideController.handleTapGesture(_:)))
		tapGestureRecognizer.cancelsTouchesInView = false
		
		panGestureRecognizer.delegate = self
		leftEdgePanGestureRecognizer.delegate = self
		rightEdgePanGestureRecognizer.delegate = self
		tapGestureRecognizer.delegate = self
		
		addChildViewController(centerViewController)
		view.addSubview(centerViewController.view)
		centerViewController.didMove(toParentViewController: self)
		
		if useScreenEdgePanGestureRecognizer {
			centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
			centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
		} else {
			centerViewController.view.addGestureRecognizer(panGestureRecognizer)
		}
		centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
		
		if statusBarBackgroundColor != nil {
			statusBarBackgroundView.backgroundColor = statusBarBackgroundColor!.withAlphaComponent(0.0)
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
		case .leftExpanded:
			toggleLeftViewController()
		case .rightExpanded:
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
		let leftViewControllerShouldExapnd = (state != .leftExpanded)
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
	
	fileprivate func animateLeftViewControllerShouldExpand(_ shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			replaceViewController(rightViewController, withViewController: leftViewController)
			rightViewControllerAdded = false
			leftViewControllerAdded = true
			
			state = .leftExpanding
			animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, completion: { [unowned self] finished -> Void in
				self.leftViewController?.didMove(toParentViewController: self)
				self.state = .leftExpanded
				completion?(finished)
			})
		} else {
			state = .leftCollapsing
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
		let rightViewControllerShouldExapnd = (state != .rightExpanded)
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
	
	fileprivate func animateRightViewControllerShouldExpand(_ shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
		if shouldExpand {
			replaceViewController(leftViewController, withViewController: rightViewController)
			leftViewControllerAdded = false
			rightViewControllerAdded = true
			
			state = .rightExpanding
			animateCenterViewControllerWithXOffset(-(rightRevealWidth ?? revealWidth), completion: { [unowned self] finished -> Void in
				self.rightViewController?.didMove(toParentViewController: self)
				self.state = .rightExpanded
				completion?(finished)
			})
		} else {
			state = .rightCollapsing
			animateCenterViewController({ finished in
				completion?(finished)
			})
		}
	}
	
	/**
	Go to state .NotExpanded
	*/
	fileprivate func animateCenterViewController(_ completion: ((Bool) -> Void)? = nil) {
		animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] finished -> Void in
			switch self.state {
			case .leftExpanding, .leftExpanded:
				self.removeViewController(self.leftViewController!)
				self.leftViewControllerAdded = false
			case .rightExpanding, .rightExpanded:
				self.removeViewController(self.rightViewController!)
				self.rightViewControllerAdded = false
			default:
				break
			}
			completion?(finished)
			self.state = .notExpanded
		})
	}
	
	fileprivate func animateCenterViewControllerWithXOffset(_ xOffset: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
		let animationClosure: () -> Void = { [unowned self] in
			self.centerViewController.view.center = CGPoint(x: self.view.center.x + xOffset, y: self.centerViewController.view.center.y)
			self.centerViewController.view.frame.origin.y = 0
			self.statusBarBackgroundView.backgroundColor = self.statusBarBackgroundColor?.withAlphaComponent(abs(xOffset) / (xOffset > 0 ? (self.leftRevealWidth ?? self.revealWidth) : (self.rightRevealWidth ?? self.revealWidth)))
			self.isAnimating = false
		}
		
		if !animated {
			animationClosure()
			completion?(true)
			return
		}
		
		if let springDampin = springDampin, let initialSpringVelocity = initialSpringVelocity, shouldExceedRevealWidth == true {
			isAnimating = true
			UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDampin, initialSpringVelocity: initialSpringVelocity, options: [.beginFromCurrentState, .curveEaseInOut], animations: animationClosure, completion: completion)
		} else {
			isAnimating = true
			UIView.animate(withDuration: animationDuration, animations: animationClosure, completion: completion)
		}
	}
	
	fileprivate func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
		if shouldShowShadow {
			centerViewController.view.layer.shadowOpacity = 0.5
		} else {
			centerViewController.view.layer.shadowOpacity = 0.0
		}
	}
	
	fileprivate func replaceViewController(_ viewController: UIViewController?, withViewController: UIViewController?) {
		if let viewController = viewController, childViewControllers.contains(viewController) {
			removeViewController(viewController)
		}
		
		if let withViewController = withViewController, !childViewControllers.contains(withViewController) {
			addViewController(withViewController)
		}
	}
	
	fileprivate func removeViewController(_ viewController: UIViewController) {
		viewController.willMove(toParentViewController: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	fileprivate func addViewController(_ viewController: UIViewController) {
		addChildViewController(viewController)
		view.insertSubview(viewController.view, belowSubview: centerViewController.view)
	}
}

extension SlideController: UIGestureRecognizerDelegate {
	@objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			switch state {
			case .notExpanded:
				// If going to expand
				showShadowForCenterViewController(true)
				let velocity = recognizer.velocity(in: view)
				if velocity.x > 0 && leftViewController != nil {
					// Show left
					beginViewController(leftViewController, appearanceTransition: true, animated: true)
					state = .leftExpanding
					beginViewController(centerViewController, appearanceTransition: false, animated: true)
				} else if velocity.x < 0 && rightViewController != nil {
					// Show right
					beginViewController(rightViewController, appearanceTransition: true, animated: true)
					state = .rightExpanding
					beginViewController(centerViewController, appearanceTransition: false, animated: true)
				}
				
			case .leftExpanded:
				// If going to collapse from left
				beginViewController(leftViewController, appearanceTransition: false, animated: true)
				state = .leftCollapsing
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			case .rightExpanded:
				// If going to collapse from right
				beginViewController(rightViewController, appearanceTransition: false, animated: true)
				state = .rightCollapsing
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			default:
				assertionFailure()
			}
		case .changed:
			let centerX = view.bounds.width / 2.0
			let centerXToBe = recognizer.view!.center.x + recognizer.translation(in: view).x
			
			if recognizer.view!.center.x > centerX {
				// Showing left
				
				// If there's no left view controller, no need for vc configuration
				if leftViewController == nil {
					recognizer.setTranslation(CGPoint.zero, in: view)
					return
				}
				
				if !leftViewControllerAdded {
					replaceViewController(rightViewController, withViewController: leftViewController)
					rightViewControllerAdded = false
					leftViewControllerAdded = true
				}
				
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (leftRevealWidth ?? revealWidth), 1.0))
				
				// If revealed width is greater than reveal width set, stop it
				if shouldExceedRevealWidth == false && (centerXToBe - centerX >= leftRevealWidth ?? revealWidth){
					recognizer.view!.center.x = centerX + (leftRevealWidth ?? revealWidth)
					recognizer.setTranslation(CGPoint.zero, in: view)
					return
				}
				
			} else if recognizer.view!.center.x < centerX {
				// Showing right
				if rightViewController == nil {
					recognizer.setTranslation(CGPoint.zero, in: view)
					return
				}
				if !rightViewControllerAdded {
					replaceViewController(leftViewController, withViewController: rightViewController)
					leftViewControllerAdded = false
					rightViewControllerAdded = true
				}
				
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (rightRevealWidth ?? revealWidth), 1.0))
				
				if shouldExceedRevealWidth == false && (centerX - centerXToBe >= rightRevealWidth ?? revealWidth){
					recognizer.view!.center.x = centerX - (rightRevealWidth ?? revealWidth)
					recognizer.setTranslation(CGPoint.zero, in: view)
					return
				}
			}
			
			// If resultCenterX is invalid, stop
			if (leftViewController == nil && centerXToBe >= centerX) || (rightViewController == nil && centerXToBe <= centerX) {
				recognizer.view!.center.x = centerX
				recognizer.setTranslation(CGPoint.zero, in: view)
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(0)
				return
			}
			
			recognizer.view!.center.x = centerXToBe
			recognizer.setTranslation(CGPoint.zero, in: view)
		case .ended:
			let velocity = recognizer.velocity(in: view)
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
					case .leftCollapsing:
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
					case .rightCollapsing:
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
			case .leftExpanding:
				beginViewController(leftViewController, appearanceTransition: false, animated: true)
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			case .rightExpanding:
				beginViewController(rightViewController, appearanceTransition: false, animated: true)
				beginViewController(centerViewController, appearanceTransition: true, animated: true)
				
			default:
				break
			}
			
			animateCenterViewController({ [unowned self] _ in
				switch self.state {
				case .leftExpanding, .leftCollapsing:
					self.endViewControllerAppearanceTransition(self.leftViewController)
					self.endViewControllerAppearanceTransition(self.centerViewController)
				case .rightExpanding, .rightCollapsing:
					self.endViewControllerAppearanceTransition(self.rightViewController)
					self.endViewControllerAppearanceTransition(self.centerViewController)
				default:
					break
				}
			})
		}
	}
	
	@objc func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
		// Tap center view controller to collapse
		if state != .notExpanded {
			collapse()
		}
	}
}

extension SlideController {
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		// If one side view controller is nil, stop to reveal it
		if gestureRecognizer == panGestureRecognizer {
			if state == .notExpanded {
				if panGestureRecognizer.velocity(in: view).x > 0 {
					return leftViewController != nil
				} else if panGestureRecognizer.velocity(in: view).x < 0 {
					return rightViewController != nil
				}
			}
		}
		
		return true
	}
}

extension SlideController {
	fileprivate func beginViewController(_ viewController: UIViewController?, appearanceTransition isAppearing: Bool, animated: Bool) {
		if isVisible {
			viewController?.beginAppearanceTransition(isAppearing, animated: animated)
		}
	}
	
	fileprivate func endViewControllerAppearanceTransition(_ viewController: UIViewController?) {
		if isVisible {
			viewController?.endAppearanceTransition()
		}
	}
}
