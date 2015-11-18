//
//  DropPresentingAnimator.swift
//  2048 Solver
//
//  Created by Honghao Zhang on 3/29/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

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
	
	public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.5))
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
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
			
            presentingView.tintAdjustmentMode = .Dimmed
			switch overlayViewStyle {
			case .Blurred(let style, let color):
				presentingView.addBlurredOverlayView(animated: true, duration: animationDuration, blurEffectStyle: style, blurredViewBackgroundColor: color)
			case .Dimmed(let color):
				presentingView.addDimmedOverlayView(animated: true, duration: animationDuration, dimmedViewBackgroundColor: color)
			}
			
            // Begin Values
			presentedView.bounds = CGRect(origin: CGPointZero, size: presentingViewSize)
			presentedView.center = CGPoint(x: containerView.bounds.width / 2.0, y: 0 - presentingViewSize.height / 2.0)
			presentedView.transform = CGAffineTransformMakeRotation((CGFloat.random(-40, 40) * CGFloat(M_PI)) / 180.0)
			
            containerView.addSubview(presentedView)
			
            UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.center = containerView.center
				presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
                }, completion: { finished -> Void in
					if let presentedViewController = self.presentedViewController where self.shouldDismissOnTappingOutsideView {
						if let window = presentedViewController.view.window {
							self.currentPresentedViewController = presentedViewController
							let tapGesture = UITapGestureRecognizer(target: self, action: "outsideViewTapped:")
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
                fromView.center = CGPoint(x: containerView.bounds.width / 2.0, y: containerView.bounds.height + self.presentingViewSize.height)
                fromView.transform = CGAffineTransformMakeRotation((CGFloat.random(-40, 40) * CGFloat(M_PI)) / 180.0)
                }, completion: { finished -> Void in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

extension DropPresentingAnimator {
	func outsideViewTapped(sender: AnyObject) {
		if let dismissTapGesture = self.dismissTapGesture {
			currentPresentedViewController?.view.window?.removeGestureRecognizer(dismissTapGesture)
		}
		currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
