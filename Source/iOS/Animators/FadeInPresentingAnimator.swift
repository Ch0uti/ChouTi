//
//  FadeInPresentingAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-17.
//
//

import UIKit

public class FadeInPresentingAnimator: Animator {
	
	override init() {
		super.init()
		animationDuration = 0.5
	}
	
	public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		guard let presentedView = self.presentedView,
			let containerView = self.containerView else {
				NSLog("ERROR: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		containerView.addSubview(presentedView)
		
		if presenting {
			presentedView.alpha = 0.0
			
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.alpha = 1.0
				
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
		else {
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
				presentedView.alpha = 0.0
				}, completion: { (_) -> Void in
					transitionContext.completeTransition(transitionContext.transitionWasCancelled() == false)
			})
		}
	}
}
