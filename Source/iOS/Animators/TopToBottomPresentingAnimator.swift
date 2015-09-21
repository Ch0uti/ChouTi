//
//  TopToBottomPresentingAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-17.
//
//

import UIKit

public class TopToBottomPresentingAnimator: Animator {
	
	override init() {
		super.init()
		animationDuration = 0.5
	}
	
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		guard let presentedView = self.presentedView,
			let presentingView = self.presentingView,
			let containerView = self.containerView else {
				NSLog("ERROR: Cannot get views from UIViewControllerContextTransitioning")
				return
		}
		
		if presenting {
			containerView.addSubview(presentedView)
			
			// Set presentedView above the top edge
			presentedView.frame = CGRect(x: presentedView.frame.origin.x, y: presentedView.frame.origin.y - presentedView.bounds.height, width: presentedView.bounds.width, height: presentedView.bounds.height)
			
			// Then slide presentedView to bottom
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.frame = CGRect(x: presentedView.frame.origin.x, y: 0.0, width: presentedView.bounds.width, height: presentedView.bounds.height)
				
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
		else {
			containerView.addSubview(presentingView)
			containerView.addSubview(presentedView)
			
			// Slide presentedView up
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.frame = CGRect(x: presentedView.frame.origin.x, y: -presentedView.bounds.height, width: presentedView.bounds.width, height: presentedView.bounds.height)
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
	}
}
