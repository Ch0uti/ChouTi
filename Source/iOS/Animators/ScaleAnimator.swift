//
//  ScaleAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-09.
//
//

import UIKit

public class ScalePresentingAnimator: Animator {
    
    public var presentingInitialScaleFactor: CGFloat = 1.2
    public var presentingFinalScaleFactor: CGFloat = 1.0
    public var presentingInitialAlpha: CGFloat = 0.0
    public var presentingFinalAlpha: CGFloat = 1.0
    
    public var dismissingInitialScaleFactor: CGFloat { return presentingFinalScaleFactor }
    public var dismissingFinalScaleFactor: CGFloat = 1.0
    public var dismissingInitialAlpha: CGFloat { return presentingFinalAlpha }
    public var dismissingFinalAlpha: CGFloat = 0.0
    
    public var overlayViewStyle: OverlayViewStyle = .Normal(UIColor(white: 0.0, alpha: 0.4))
    
    /// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
    public var shouldDimPresentedView: Bool = true
    
    public override init() {
        super.init()
        animationDuration = 0.3
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ScalePresentingAnimator {
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
            let presentedViewController = self.presentedViewController,
            let presentedView = presentedViewController.view,
            let containerView = self.containerView else {
                NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
                return
        }
        
        presentedView.size = presentedViewController.preferredContentSize //?? CGSizeZero// CGSize(width: presentedViewDefaultWidth, height: presentedViewDefaultHeight)
        containerView.addSubview(presentedView)
        
        // Initial state
        presentedView.alpha = presentingInitialAlpha
        presentedView.transform = CGAffineTransformMakeScale(presentingInitialScaleFactor, presentingInitialScaleFactor)
        presentedView.center = containerView.center
        
        // Presenting animations
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: { [unowned self] in
            presentedView.alpha = self.presentingFinalAlpha
            presentedView.transform = CGAffineTransformMakeScale(self.presentingFinalScaleFactor, self.presentingFinalScaleFactor)
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    private func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // Necessary setup for dismissing
        guard
            let fromView = self.fromViewController?.view,
            let containerView = self.containerView else {
                NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
                return
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,  options: .CurveEaseInOut, animations: { [unowned self] in
            fromView.transform = CGAffineTransformMakeScale(self.dismissingFinalScaleFactor, self.dismissingFinalScaleFactor)
            fromView.alpha = self.dismissingFinalAlpha
            }) { finished in
                transitionContext.completeTransition(finished)
        }
    }
    
    public override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let overlayPresentationController = OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle)
        overlayPresentationController.shouldDismissOnTappingOutsideView = false
        overlayPresentationController.shouldDimPresentedView = shouldDimPresentedView
        
        return overlayPresentationController
    }
}
