//
//  UIViewController+Utility.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-08-11.
//
//

import UIKit



public class SlideController: UIViewController {
	public enum SlideState {
		case NotExpanded
		case LeftExpanded
		case RightExpanded
	}
	
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

	public var leftViewController: UIViewController?
	public var rightViewController: UIViewController?
	
	public var state: SlideState = .NotExpanded {
		didSet {
			showShadowForCenterViewController(state != .NotExpanded)
		}
	}
	
	public var slideWidth: CGFloat = 0.75 * UIScreen.mainScreen().bounds.width
	public var animationDuration: NSTimeInterval = 0.25
	public var initialSpringVelocity: CGFloat = 0.0
	public var springDampin: CGFloat = 0.0
	
	private var leftViewControllerAdded: Bool = false
	private var rightViewControllerAdded: Bool = false
	
	private var panGestureRecognizer = UIPanGestureRecognizer()
	
	public convenience init(centerViewController: UIViewController) {
		self.init(centerViewController: centerViewController, leftViewController: nil, rightViewController: nil)
	}
	
	public init(centerViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
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
		
		addChildViewController(centerViewController)
		view.addSubview(centerViewController.view)
		centerViewController.didMoveToParentViewController(self)
		centerViewController.view.addGestureRecognizer(panGestureRecognizer)
	}
}

extension SlideController {
	public func toggleLeftViewController() {
		let leftViewControllerIsAlreadyExpanded = (state == .LeftExpanded)
		if !leftViewControllerIsAlreadyExpanded {
			replaceViewController(rightViewController, withViewController: leftViewController)
			rightViewControllerAdded = false
			leftViewControllerAdded = true
		}
		
		animateLeftViewController(shouldExpand: !leftViewControllerIsAlreadyExpanded)
	}
	
	private func animateLeftViewController(#shouldExpand: Bool) {
		if shouldExpand {
			state = .LeftExpanded
			animateCenterViewControllerWithXOffset(slideWidth, completion: nil)
		} else {
			animateCenterViewControllerWithXOffset(0.0, completion: { _ -> Void in
				self.state = .NotExpanded
				self.removeViewController(self.leftViewController)
				self.leftViewControllerAdded = false
			})
		}
	}
	
	public func toggleRightViewController() {
		let rightViewControllerIsAlreadyExpanded = (state == .RightExpanded)
		if !rightViewControllerIsAlreadyExpanded {
			replaceViewController(leftViewController, withViewController: rightViewController)
			leftViewControllerAdded = false
			rightViewControllerAdded = true
		}
		
		animateRightViewController(shouldExpand: !rightViewControllerIsAlreadyExpanded)
	}
	
	private func animateRightViewController(#shouldExpand: Bool) {
		if shouldExpand {
			state = .RightExpanded
			animateCenterViewControllerWithXOffset(-slideWidth, completion: nil)
		} else {
			animateCenterViewControllerWithXOffset(0.0, completion: { _ -> Void in
				self.state = .NotExpanded
				self.removeViewController(self.rightViewController)
				self.rightViewControllerAdded = false
			})
		}
	}
	
	private func animateCenterViewController() {
		animateCenterViewControllerWithXOffset(0.0, completion: { _ -> Void in
			self.state = .NotExpanded
			self.removeViewController(self.leftViewController)
			self.leftViewControllerAdded = false
			self.removeViewController(self.rightViewController)
			self.rightViewControllerAdded = false
		})
	}
	
	private func animateCenterViewControllerWithXOffset(xOffset: CGFloat, completion: ((Bool) -> Void)? = nil) {
		let animationClosure: () -> Void = {
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
			viewController.didMoveToParentViewController(self)
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
			if recognizer.view!.center.x > view.bounds.size.width / 2.0 {
				// Showing left
				if !leftViewControllerAdded {
					replaceViewController(rightViewController, withViewController: leftViewController)
					rightViewControllerAdded = false
					leftViewControllerAdded = true
				}
			} else if recognizer.view!.center.x < view.bounds.size.width / 2.0 {
				// Showing right
				if !rightViewControllerAdded {
					replaceViewController(leftViewController, withViewController: rightViewController)
					leftViewControllerAdded = false
					rightViewControllerAdded = true
				}
			}
			recognizer.view!.center.x += recognizer.translationInView(view).x
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
				if recognizer.view!.center.x > view.bounds.size.width {
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
}
