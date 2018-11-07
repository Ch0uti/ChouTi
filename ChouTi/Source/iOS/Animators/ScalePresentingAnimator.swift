//
//  ScalePresentingAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-09.
//
//

import UIKit

open class ScalePresentingAnimator: Animator {

    open var presentingInitialScaleFactor: CGFloat = 1.2
    open var presentingFinalScaleFactor: CGFloat = 1.0
    open var presentingInitialAlpha: CGFloat = 0.0
    open var presentingFinalAlpha: CGFloat = 1.0

    open var dismissingInitialScaleFactor: CGFloat { return presentingFinalScaleFactor }
    open var dismissingFinalScaleFactor: CGFloat = 1.0
    open var dismissingInitialAlpha: CGFloat { return presentingFinalAlpha }
    open var dismissingFinalAlpha: CGFloat = 0.0

    open var overlayViewStyle: OverlayViewStyle = .normal(UIColor(white: 0.0, alpha: 0.4))

    /// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
    open var shouldDimPresentedView: Bool = true

    override public init() {
        super.init()

        animationDuration = 0.3
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ScalePresentingAnimator {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        if presenting {
            presentingAnimation(transitionContext)
        } else {
            dismissingAnimation(transitionContext)
        }
    }

    private func presentingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        // Necessary setup for presenting
        guard
            let presentedViewController = self.presentedViewController,
            let presentedView = presentedViewController.view,
            let containerView = self.containerView else {
                NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
                return
        }

        presentedView.size = presentedViewController.preferredContentSize
        containerView.addSubview(presentedView)

        // Initial state
        presentedView.alpha = presentingInitialAlpha
        presentedView.transform = CGAffineTransform(scaleX: presentingInitialScaleFactor, y: presentingInitialScaleFactor)
        presentedView.center = containerView.center

        // Presenting animations
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { [unowned self] in
            presentedView.alpha = self.presentingFinalAlpha
            presentedView.transform = CGAffineTransform(scaleX: self.presentingFinalScaleFactor, y: self.presentingFinalScaleFactor)
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }

    private func dismissingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        // Necessary setup for dismissing
        guard let fromView = self.fromViewController?.view else {
			NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
			return
        }

        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut,
                       animations: { [unowned self] in
                        fromView.transform = CGAffineTransform(scaleX: self.dismissingFinalScaleFactor, y: self.dismissingFinalScaleFactor)
                        fromView.alpha = self.dismissingFinalAlpha
            }, completion: { finished in
                transitionContext.completeTransition(finished)
        })
    }
}

// MARK: - UIViewControllerTransitioningDelegate
public extension ScalePresentingAnimator {
    override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let overlayPresentationController = OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle)
        overlayPresentationController.shouldDismissOnTappingOutsideView = false
        overlayPresentationController.shouldDimPresentedView = shouldDimPresentedView

        return overlayPresentationController
    }
}
