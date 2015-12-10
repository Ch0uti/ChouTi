//
//  DropDownMenuAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-03.
//
//

import UIKit

public class DropDownMenuAnimator: Animator {
	
	public override init() {
		super.init()
		animationDuration = 0.5
	}
	
	// Customize overlay view style
	public enum OverlayViewStyle {
		case Dimmed(UIColor)
		case Blurred(UIBlurEffectStyle, UIColor)
	}
	
	public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.5))
	
	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	public var shouldDimPresentedView: Bool = false
	
	/// View tag for transparent overlay view, this transparent view is used for floating menu view
	private let transparentOverlayViewTag: Int = 998
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
	// Drop Down Menu Related
	public weak var dropDownMenu: DropDownMenu?
	
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		if presenting {
			// Necessary setup for presenting
			guard
				let presentingView = self.presentingViewController?.view,
				let presentedView = self.presentedViewController?.view,
				let containerView = self.containerView else {
					NSLog("ERROR: Cannot get view from UIViewControllerContextTransitioning")
					return
			}
			
			guard let dropDownMenu = dropDownMenu else {
				NSLog("dropDownMenu is nil")
				return
			}
			
			// Begining settings
			if shouldDimPresentedView {
				presentingView.tintAdjustmentMode = .Dimmed
			}
			
			let menuFrame = dropDownMenu.frameRectInView(containerView)
			presentedView.frame = CGRect(x: 0, y: menuFrame.bottom, width: containerView.width, height: containerView.height - menuFrame.bottom)
			
			containerView.addSubview(presentedView)
			
			// Add darker overlay view
			switch overlayViewStyle {
			case .Blurred(let style, let color):
				presentingView.addBlurredOverlayView(animated: true, duration: animationDuration, blurEffectStyle: style, blurredViewBackgroundColor: color)
			case .Dimmed(let color):
				presentingView.addOverlayView(animated: true, duration: animationDuration, overlayViewBackgroundColor: color)
			}
			
			// Add a transparent overlay view, this view is used for floating menu view
			let transparentOverlayView = presentingView.addOverlayView(animated: false, overlayViewBackgroundColor: UIColor.clearColor(), viewTag: transparentOverlayViewTag)
			// Keep menu view at the top (dropDownMenu.wrapperView is the containerView for all subviews)
			transparentOverlayView.addSubview(dropDownMenu.wrapperView)
			dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
			dropDownMenu.setupWrapperViewConstraints()

			// Presenting animations
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
//				presentedView.center = containerView.center
//				presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
				}, completion: { finished -> Void in
					// TODO: Handle tapping
					if let presentedViewController = self.presentedViewController where self.shouldDismissOnTappingOutsideView {
						if let window = presentedViewController.view.window {
							self.currentPresentedViewController = presentedViewController
							let tapGesture = UITapGestureRecognizer(target: self, action: "outsideViewTapped:")
							tapGesture.delegate = self
							window.addGestureRecognizer(tapGesture)
							self.dismissTapGesture = tapGesture
						}
					}
					
					transitionContext.completeTransition(true)
			})
		} else {
			// Necessary setup for dismissing
			guard
				let toView = self.toViewController?.view else {
					NSLog("ERROR: Cannot get view from UIViewControllerContextTransitioning")
					return
			}
			
			guard let dropDownMenu = dropDownMenu else {
				NSLog("dropDownMenu is nil")
				return
			}
			
			// Begining settings
			if shouldDimPresentedView {
				toView.tintAdjustmentMode = .Normal
			}
			
			// Restore menu wrapper view closure
			let restoreMenu = {
				dropDownMenu.addSubview(dropDownMenu.wrapperView)
				dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
				dropDownMenu.setupWrapperViewConstraints()
				toView.removeOverlayView(animated: false, viewTag: self.transparentOverlayViewTag)
			}
			
			// Remove overlay view
			switch overlayViewStyle {
			case .Blurred:
				toView.removeBlurredOverlayView(animated: true, duration: animationDuration, completion: { _ in
					restoreMenu()
					transitionContext.completeTransition(true)
				})
			case .Dimmed:
				toView.removeOverlayView(animated: true, duration: animationDuration, completion: { _ in
					restoreMenu()
					transitionContext.completeTransition(true)
				})
			}
			
//			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: { () -> Void in
//				// No animations
//				toView.tintAdjustmentMode = .Normal
//				}, completion: { finished -> Void in
//					transitionContext.completeTransition(true)
//			})
		}
	}
}

extension DropDownMenuAnimator : UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let currentPresentedViewController = self.currentPresentedViewController else {
			return true
		}
		
		// Disable tap action for presented view area
		let locationOnPresentingView = gestureRecognizer.locationInView(currentPresentedViewController.view)
		if currentPresentedViewController.view.bounds.contains(locationOnPresentingView) {
			return false
		} else {
			return true
		}
	}
}

extension DropDownMenuAnimator {
	func outsideViewTapped(sender: AnyObject) {
		if let dismissTapGesture = self.dismissTapGesture {
			currentPresentedViewController?.view.window?.removeGestureRecognizer(dismissTapGesture)
		}
		currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
