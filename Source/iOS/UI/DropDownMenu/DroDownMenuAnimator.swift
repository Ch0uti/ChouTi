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
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
	// Drop Down Menu Related
	public weak var dropDownMenu: DropDownMenu?
	
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		if presenting {
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
			
			presentingView.tintAdjustmentMode = .Dimmed
			if presentingView.window!.containSubview(dropDownMenu) {
				//
			}
			switch overlayViewStyle {
			case .Blurred(let style, let color):
				presentingView.window?.insertBlurredOverlayViewBelowSubview(dropDownMenu, animated: true, duration: animationDuration / 2.0, blurEffectStyle: style, blurredViewBackgroundColor: color)
			case .Dimmed(let color):
				presentingView.window?.insertDimmedOverlayViewBelowSubview(dropDownMenu, animated: true, duration: animationDuration / 2.0, dimmedViewBackgroundColor: color)
			}
			
			presentedView.alpha = 0.0
			presentedView.bounds = CGRectZero
			
			// Begin Values
			containerView.addSubview(presentedView)
			
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
				presentedView.center = containerView.center
				presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
				}, completion: { finished -> Void in
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
			guard
				let toView = self.toViewController?.view,
				let fromView = self.fromViewController?.view,
				let containerView = self.containerView else {
					NSLog("ERROR: Cannot get view from UIViewControllerContextTransitioning")
					return
			}
			
			toView.tintAdjustmentMode = .Normal
			switch overlayViewStyle {
			case .Blurred:
				toView.removeBlurredOverlayView(animated: true, duration: animationDuration)
			case .Dimmed:
				toView.removeDimmedOverlayView(animated: true, duration: animationDuration)
			}
			
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				}, completion: { finished -> Void in
					transitionContext.completeTransition(true)
			})
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
