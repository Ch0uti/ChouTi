//
//  DropPresentingAnimator.swift
//  2048 Solver
//
//  Created by Honghao Zhang on 3/29/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

// Sample Usage:
//let <#animator#> = DropPresentingAnimator()
//
//<#animator#>.animationDuration = 0.75
//<#animator#>.shouldDismissOnTappingOutsideView = true
//<#animator#>.presentingViewSize = CGSize(width: ceil(screenWidth * 0.7), height: 160)
//<#animator#>.overlayViewStyle = .Dimmed(UIColor(white: 0.2, alpha: 1.0))
//
//<#presentedViewController#>.modalPresentationStyle = .Custom
//<#presentedViewController#>.transitioningDelegate = animator
//
//presentViewController(<#presentedViewController#>, animated: true, completion: nil)

import UIKit

public class DropPresentingAnimator: Animator {
	
	public override init() {
		super.init()
		animationDuration = 0.5
	}
	
    public var presentingViewSize = CGSize(width: 300, height: 200)
	
	// Customize overlay view style
	public enum OverlayViewStyle {
		case Dimmed(UIColor)
		case Blurred(UIBlurEffectStyle, UIColor)
	}
	
	public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.85))
	
	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	public var shouldDimPresentedView: Bool = false
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	
	// Drag to dismiss (interactive)
	public var allowDragToDismiss: Bool = true
	
	// MARK: - Private
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var longPressGesture: UILongPressGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
	private var panBeginLocation: CGPoint?
	private var interactiveAnimationDraggingRange: CGFloat?
	private var interactiveAnimationTransformAngel: CGFloat?
}



// MARK: - UIViewControllerAnimatedTransitioning
extension DropPresentingAnimator {
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		if presenting {
			presentingAnimation(transitionContext)
		} else {
			dismissingAnimation(transitionContext)
		}
	}
	
	private func presentingAnimation(transitionContext: UIViewControllerContextTransitioning?) {
		// Necessary setup for presenting
		guard let transitionContext = transitionContext else {
			NSLog("Error: transitionContext is nil")
			return
		}
		
		guard
			let presentingView = self.presentingViewController?.view,
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		// Add darker overlay view
		switch overlayViewStyle {
		case .Blurred(let style, let color):
			presentingView.addBlurredOverlayView(animated: true, duration: animationDuration / 2.0, blurEffectStyle: style, blurredViewBackgroundColor: color)
		case .Dimmed(let color):
			presentingView.addOverlayView(animated: true, duration: animationDuration / 2.0, overlayViewBackgroundColor: color)
		}
		
		// Begin Values
		if shouldDimPresentedView {
			presentingView.tintAdjustmentMode = .Dimmed
		}
		
		presentedView.bounds = CGRect(origin: CGPointZero, size: presentingViewSize)
		presentedView.center = CGPoint(x: containerView.bounds.width / 2.0, y: 0 - presentingViewSize.height / 2.0)
		presentedView.transform = CGAffineTransformMakeRotation((CGFloat.random(-40, 40) * CGFloat(M_PI)) / 180.0)
		
		containerView.addSubview(presentedView)
		
		// Presenting animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			presentedView.center = containerView.center
			presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
			}, completion: { [unowned self] finished -> Void in
				self.currentPresentedViewController = self.presentedViewController
				
				// Adding gestures to presenting view controller
				if let presentingViewController = self.presentingViewController {
					if let window = presentingViewController.view.window {
						if self.shouldDismissOnTappingOutsideView {
							let tapGesture = UITapGestureRecognizer(target: self, action: "windowTapped:")
							tapGesture.delegate = self
							window.addGestureRecognizer(tapGesture)
							self.dismissTapGesture = tapGesture
						}
						
						if self.allowDragToDismiss {
							let longPressGesture = UILongPressGestureRecognizer(target: self, action: "windowPanned:")
							longPressGesture.minimumPressDuration = 0.01
							longPressGesture.delegate = self
							window.addGestureRecognizer(longPressGesture)
							self.longPressGesture = longPressGesture
						}
					}
				}
				
				transitionContext.completeTransition(finished)
		})
	}
	
	private func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning?) {
		// Necessary setup for dismissing
		guard let transitionContext = transitionContext else {
			NSLog("Error: transitionContext is nil")
			return
		}
		
		guard
			let toView = self.toViewController?.view,
			let fromView = self.fromViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		// Begining settings
		if shouldDimPresentedView {
			toView.tintAdjustmentMode = .Normal
		}
		
		// Remove overlay view
		switch overlayViewStyle {
		case .Blurred:
			toView.removeBlurredOverlayView(animated: true, duration: animationDuration * 0.8)
		case .Dimmed:
			toView.removeOverlayView(animated: true, duration: animationDuration * 0.8)
		}
		
		// Dismissing animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
			fromView.center = CGPoint(x: containerView.bounds.width / 2.0, y: containerView.bounds.height + self.presentingViewSize.height)
			fromView.transform = CGAffineTransformMakeRotation((self.interactiveAnimationTransformAngel ?? CGFloat.random(-40, 40) * CGFloat(M_PI)) / 180.0)
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}
	
	public override func animationEnded(transitionCompleted: Bool) {
		panBeginLocation = nil
		interactiveAnimationDraggingRange = nil
		interactiveAnimationTransformAngel = nil
		
		if transitionCompleted == false {
			return
		}
		
		if presenting {
			// Nothing to clear for presenting
		} else {
			// Clean up for dismissing
			
			// Clean up gestures
			if let tapGesture = self.dismissTapGesture {
				presentingViewController?.view.window?.removeGestureRecognizer(tapGesture)
			}
			dismissTapGesture = nil
			
			if let longPressGesture = self.longPressGesture {
				presentingViewController?.view.window?.removeGestureRecognizer(longPressGesture)
			}
			longPressGesture = nil
			
			currentPresentedViewController = nil
		}
		
		// Call super.animationEnded at end to avoid clear transitionContext
		super.animationEnded(transitionCompleted)
	}
}



// MARK: - UIGestureRecognizerDelegate
extension DropPresentingAnimator : UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let currentPresentedViewController = self.currentPresentedViewController else {
			return true
		}
		
		let locationInPresentingView = gestureRecognizer.locationInView(currentPresentedViewController.view)
		
		// Disable tap action for presented view area
		if let tapGesture = gestureRecognizer as? UITapGestureRecognizer where tapGesture == self.dismissTapGesture {
			if currentPresentedViewController.view.bounds.contains(locationInPresentingView) {
				return false
			} else {
				return true
			}
		}
		
		// Only enable pan gesture
		if let longPressGesture = gestureRecognizer as? UILongPressGestureRecognizer where longPressGesture == self.longPressGesture {
			if currentPresentedViewController.view.bounds.contains(locationInPresentingView) {
				return true
			} else {
				return false
			}
		}
		
		return true
	}
}



// MARK: - Actions
extension DropPresentingAnimator {
	func windowTapped(sender: AnyObject) {
		interactive = false
		currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func windowPanned(sender: AnyObject) {
		guard let currentPresentedViewController = self.currentPresentedViewController else {
			return
		}
		
		if let longPressGesture = sender as? UILongPressGestureRecognizer where longPressGesture == self.longPressGesture {
			let locationInWindow = longPressGesture.locationInView(currentPresentedViewController.view.window)
			
			switch longPressGesture.state {
			case .Began:
				panBeginLocation = locationInWindow
				interactive = true
				currentPresentedViewController.dismissViewControllerAnimated(true, completion: nil)
				
			case .Changed:
				guard let panBeginLocation = panBeginLocation else {
					NSLog("Warning: pan begin location is nil")
					return
				}
				
				guard let interactiveAnimationDraggingRange = interactiveAnimationDraggingRange else {
					NSLog("Error: interactiveAnimationDraggingRange is nil")
					return
				}
				
				let yOffset = locationInWindow.y - panBeginLocation.y
				let progress = yOffset / interactiveAnimationDraggingRange
				
				updateInteractiveTransition(locationInWindow, percentComplete: progress)

			case .Ended:
				guard let panBeginLocation = panBeginLocation else {
					NSLog("Warning: pan begin location is nil")
					return
				}
				
				guard let interactiveAnimationDraggingRange = interactiveAnimationDraggingRange else {
					NSLog("Error: interactiveAnimationDraggingRange is nil")
					return
				}
				
				let yOffset = locationInWindow.y - panBeginLocation.y
				let progress = yOffset / interactiveAnimationDraggingRange
				
				// If dragging speed is large enough, finish the dismiss transition
				if longPressGesture.velocityInAttachedView().y > 1000 {
					finishInteractiveTransition()
					return
				}
				
				if progress > 0.5 {
					finishInteractiveTransition()
				} else {
					cancelInteractiveTransition()
				}
				
			default:
				cancelInteractiveTransition()
			}
		}
	}
}



// MARK: - UIViewControllerInteractiveTransitioning
extension DropPresentingAnimator {
	public override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.startInteractiveTransition(transitionContext)
		guard let currentPresentedViewController = self.currentPresentedViewController else {
			return
		}
		
		guard let window = currentPresentedViewController.view.window else {
			NSLog("Warning: current presented view controller has no window")
			return
		}
		
		interactiveAnimationDraggingRange = window.bounds.height - currentPresentedViewController.view.center.y
		interactiveAnimationTransformAngel = CGFloat.random(-40, 40)
	}
	
	// MARK: - Interactive Animations
	private func updateInteractiveTransition(draggingLocation: CGPoint, percentComplete: CGFloat) {
		if transitionContext == nil {
			NSLog("Warning: transitionContext is nil")
		}
		
		self.transitionContext?.updateInteractiveTransition(percentComplete)
		guard let panBeginLocation = panBeginLocation else {
			NSLog("Warning: pan begin location is nil")
			return
		}
		
		guard
			let fromView = self.fromViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		guard let interactiveAnimationTransformAngel = interactiveAnimationTransformAngel else {
			NSLog("Error: interactiveAnimationTransformAngel is nil")
			return
		}
		
		let yOffset = draggingLocation.y - panBeginLocation.y
		let beginPoint = containerView.center
		
		fromView.center = CGPoint(x: beginPoint.x, y: beginPoint.y + yOffset)
		fromView.transform = CGAffineTransformMakeRotation((interactiveAnimationTransformAngel * CGFloat(M_PI)) / 180.0 *  percentComplete)
	}
	
	private func cancelInteractiveTransition() {
		if transitionContext == nil {
			NSLog("Warning: transitionContext is nil")
		}
		
		if currentPresentedViewController == nil {
			NSLog("Warning: currentPresentedViewController is nil")
		}
		
		transitionContext?.cancelInteractiveTransition()
		
		if presenting {
			// If cancel presenting, which will dismiss
			currentPresentedViewController?.beginAppearanceTransition(false, animated: true)
		} else {
			// If cancel dismissing, which will present
			currentPresentedViewController?.beginAppearanceTransition(true, animated: true)
		}

		guard
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			presentedView.center = containerView.center
			presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
			}, completion: { [unowned self] finished in
				self.currentPresentedViewController?.endAppearanceTransition()
				self.transitionContext?.completeTransition(finished)
		})
	}
	
	private func finishInteractiveTransition() {
		if transitionContext == nil {
			NSLog("Warning: transitionContext is nil")
		}
		
		self.transitionContext?.finishInteractiveTransition()
		dismissingAnimation(transitionContext)
	}
}
