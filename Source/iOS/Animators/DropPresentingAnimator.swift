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
			let overlayView = presentingView.addBlurredOverlayView(animated: true, duration: animationDuration)
			// FIXME: Not finished
			let tapGesture = UITapGestureRecognizer(target: self, action: "dismiss:")
			overlayView.addGestureRecognizer(tapGesture)
			
            // Begin Values
			presentedView.bounds = CGRect(origin: CGPointZero, size: presentingViewSize)
			presentedView.center = CGPoint(x: containerView.bounds.width / 2.0, y: 0 - presentingViewSize.height / 2.0)
			presentedView.transform = CGAffineTransformMakeRotation((CGFloat.random(-40, 40) * CGFloat(M_PI)) / 180.0)
			
            containerView.addSubview(presentedView)
			
            UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.center = containerView.center
				presentedView.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
                }, completion: { finished -> Void in
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
            toView.removeBlurredOverlayView(animated: true, duration: animationDuration)
			
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
	func dismiss(sender: AnyObject) {
		
	}
}