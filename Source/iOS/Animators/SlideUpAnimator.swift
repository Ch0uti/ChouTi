//
//  SlideUpAnimator.swift
//  Pods
//
//  Created by Honghao_Zhang on 2015-12-12.
//
//

import UIKit

public class SlideUpAnimator : Animator {
	
	public var presentingViewHeight: CGFloat = 400
	public var presentingViewWidth: CGFloat?
	
	public var overlayViewStyle: OverlayViewStyle = .Normal(UIColor(white: 0.0, alpha: 0.75))
	
	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	public var shouldDimPresentedView: Bool = false
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	
	// MARK: - Private
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
	private var topConstraint: NSLayoutConstraint!
	
	public override init() {
		super.init()
		animationDuration = 0.5
	}
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SlideUpAnimator {
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		if presenting {
			presentingAnimation(transitionContext)
		} else {
			dismissingAnimation(transitionContext)
		}
	}
	
	private func presentingAnimation(transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for presenting
		guard
			let presentingView = self.presentingViewController?.view,
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		// Begining settings
		if shouldDimPresentedView {
			presentingView.tintAdjustmentMode = .Dimmed
		}
		
		// Add darker overlay view
		switch overlayViewStyle {
		case .Blurred(let style, let color):
			presentingView.addBlurredOverlayView(animated: true, duration: animationDuration, blurEffectStyle: style, blurredViewBackgroundColor: color)
		case .Normal(let color):
			presentingView.addOverlayView(animated: true, duration: animationDuration, overlayViewBackgroundColor: color)
		}
		
		presentedView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(presentedView)
		
		// Initial constraints
		presentedView.constraintHeight(presentingViewHeight)

		if let presentingViewWidth = presentingViewWidth {
			presentedView.constraintWidth(presentingViewWidth)
		} else {
			NSLayoutConstraint(item: presentedView, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: presentedView, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
		}
		
		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Add a bottom dummy view to avoid bottom of presented view is off with spring animation
		let emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(emptyView)
		
		emptyView.backgroundColor = presentedView.backgroundColor
		emptyView.constraintHeight(100.0)
		if let presentingViewWidth = presentingViewWidth {
			emptyView.constraintWidth(presentingViewWidth)
		} else {
			NSLayoutConstraint(item: emptyView, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: emptyView, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
		}
		NSLayoutConstraint(item: emptyView, attribute: .Top, relatedBy: .Equal, toItem: presentedView, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		
		// Update layout immediately
		containerView.layoutIfNeeded()
		
		// Final constraints
		topConstraint.active = false
		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Presenting animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { [unowned self] finished -> Void in
				emptyView.removeFromSuperview()
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
					}
				}
				
				transitionContext.completeTransition(finished)
			})
	}
	
	private func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for dismissing
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
		case .Normal:
			toView.removeOverlayView(animated: true, duration: animationDuration * 0.8)
		}
		
		topConstraint.active = false
		
		topConstraint = NSLayoutConstraint(item: fromView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Dismissing animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}
	
	public override func animationEnded(transitionCompleted: Bool) {
		if transitionCompleted == false {
			return
		}
		
		if presenting {
			// Nothing to clear for presenting
		} else {
			// Clean up for dismissing
			topConstraint = nil
			
			// Clean up gestures
			if let tapGesture = self.dismissTapGesture {
				presentingViewController?.view.window?.removeGestureRecognizer(tapGesture)
			}
			dismissTapGesture = nil
			currentPresentedViewController = nil
		}
		
		// Call super.animationEnded at end to avoid clear transitionContext
		super.animationEnded(transitionCompleted)
	}
}



// MARK: - UIGestureRecognizerDelegate
extension SlideUpAnimator : UIGestureRecognizerDelegate {
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
		
		return true
	}
}



// MARK: - Actions
extension SlideUpAnimator {
	public func dismisscurrentPresentedViewController() {
		windowTapped(dismissTapGesture)
	}
	
	func windowTapped(sender: AnyObject?) {
		interactive = false
		currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
