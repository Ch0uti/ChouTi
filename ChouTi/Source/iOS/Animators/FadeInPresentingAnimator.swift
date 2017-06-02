//
//  FadeInPresentingAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-17.
//
//

import UIKit

open class FadeInPresentingAnimator: Animator {
	
    open var overlayViewStyle: OverlayViewStyle = .normal(UIColor(white: 0.0, alpha: 0.7))
    
    /// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
    open var shouldDimPresentedView: Bool = true
    
	public override init() {
		super.init()
		animationDuration = 0.3
	}
}

// MARK: - UIViewControllerAnimatedTransitioning
extension FadeInPresentingAnimator {
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
        if presenting {
            presentingAnimation(transitionContext)
        } else {
            dismissingAnimation(transitionContext)
        }
    }
    
    private func presentingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedViewController = self.presentedViewController,
            let presentedView = presentedViewController.view,
            let containerView = self.containerView else {
                NSLog("ERROR: Cannot get view from UIViewControllerContextTransitioning")
                return
        }
        
        if presentedViewController.preferredContentSize != .zero {
            presentedView.size = presentedViewController.preferredContentSize
        } else {
            presentedView.size = containerView.size
        }
        containerView.addSubview(presentedView)
        
        // Initial state
        presentedView.alpha = 0.0
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: { _ in
            presentedView.alpha = 1.0
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    private func dismissingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = self.fromViewController?.view else {
            NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
            return
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: { _ in
            fromView.alpha = 0.0
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension FadeInPresentingAnimator {
    public override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let overlayPresentationController = OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle)
        overlayPresentationController.shouldDismissOnTappingOutsideView = false
        overlayPresentationController.shouldDimPresentedView = shouldDimPresentedView
        
        return overlayPresentationController
    }
}
