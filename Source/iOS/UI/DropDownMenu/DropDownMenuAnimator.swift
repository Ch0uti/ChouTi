//
//  DropDownMenuAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-03.
//
//

import UIKit

class DropDownMenuAnimator: Animator {
	
	override init() {
		super.init()
		animationDuration = 0.5
	}
	
    weak var dropDownMenu: DropDownMenu?
    
	/// Overlay view style. By default, it's Dark blur effect
	var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.5))
	
	/// Whether presenting view should be dimmed when presenting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	var shouldDimPresentedView: Bool = false
	
	/// Whether should dismiss presented view when tap out side of presented view
	var shouldDismissOnTappingOutsideView: Bool = true
	
	override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(transitionContext)
		
		if presenting {
			presentingAnimation(transitionContext)
		} else {
			dismissingAnimation(transitionContext)
		}
	}
	
	/**
	Presenting animation.
	
	- parameter transitionContext: transitionContext
	*/
	private func presentingAnimation(transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for presenting
		guard
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
        
        containerView.addSubview(presentedView)
		
		// Presenting animations
		presentedView.alpha = 0.999999 // presentedView.alpha is set to 1.0 in following animation block. This is make sure animation has a correct duration
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			presentedView.alpha = 1.0
			}, completion: { finished -> Void in
				transitionContext.completeTransition(true)
		})
	}
	
	/**
	Dismissing animations
	
	- parameter transitionContext: transitionContext
	*/
	private func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for dismissing
		guard let fromView = self.fromViewController?.view else {
            NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
            return
		}
				
		fromView.alpha = 0.999999
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: { () -> Void in
			fromView.alpha = 1.0
			}, completion: { finished -> Void in
				transitionContext.completeTransition(true)
		})
	}
    
    override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = DropDownMenuPresentationController(presentedViewController: presented, presentingViewController: presenting!, overlayViewStyle: overlayViewStyle)
        presentationController.shouldDismissOnTappingOutsideView = shouldDismissOnTappingOutsideView
        presentationController.shouldDimPresentedView = shouldDimPresentedView
        
        presentationController.dropDownMenu = dropDownMenu
        
        return presentationController
    }
}
