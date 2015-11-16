//
//  LeftToRightSlideAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-17.
//
//

import UIKit

public class LeftToRightSlideAnimator: Animator {
	
	public override init() {
		super.init()
		animationDuration = 0.25
	}
	
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		guard let presentedView = self.presentedView,
			let presentingView = self.presentingView,
			let containerView = self.containerView else {
			NSLog("ERROR: Cannot get views from UIViewControllerContextTransitioning")
			return
		}
		
		containerView.addSubview(presentingView)
		containerView.addSubview(presentedView)
		
		if presenting {
			// Set presentedView on the left edge
			presentedView.frame = CGRect(x: presentedView.frame.origin.x - presentedView.bounds.width, y: presentedView.frame.origin.y, width: presentedView.bounds.width, height: presentedView.bounds.height)
			
			// Then slide presentingView and presentedView to right
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.frame = CGRect(x: 0.0, y: presentedView.frame.origin.y, width: presentedView.bounds.width, height: presentedView.bounds.height)
				presentingView.frame = CGRect(x: presentingView.bounds.size.width, y: presentingView.frame.origin.y, width: presentingView.bounds.width, height: presentingView.bounds.height)
				
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
		else {
			// Make sure presentingView is on the right edge
			presentingView.frame = CGRect(x: presentingView.bounds.width, y: presentingView.frame.origin.y, width: presentingView.bounds.width, height: presentingView.bounds.height)
			
			// Then slide presentingView and presentedView to left
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.frame = CGRect(x: -presentedView.bounds.width, y: presentedView.frame.origin.y, width: presentedView.bounds.width, height: presentedView.bounds.height)
				presentingView.frame = CGRect(x: 0.0, y: presentingView.frame.origin.y, width: presentingView.bounds.width, height: presentingView.bounds.height)
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
	}
}
