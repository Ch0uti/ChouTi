//
//  SlideUpAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

open class SlideUpAnimator: Animator {

	open var presentedViewHeight: CGFloat = 400
	open var presentedViewWidth: CGFloat?

	open var overlayViewStyle: OverlayViewStyle = .normal(UIColor(white: 0.0, alpha: 0.75))

	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	open var shouldDimPresentedView: Bool = false

	// Tap to dismiss
	open var shouldDismissOnTappingOutsideView: Bool = true

	private var topConstraint: NSLayoutConstraint!

	public override init() {
		super.init()
		animationDuration = 0.5
	}
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SlideUpAnimator {
	public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}

		presentedView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(presentedView)

		// Initial constraints
        presentedView.constrainTo(height: presentedViewHeight)

		if let presentedViewWidth = presentedViewWidth {
            presentedView.constrainTo(width: presentedViewWidth)
		} else {
			NSLayoutConstraint(item: presentedView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
			NSLayoutConstraint(item: presentedView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
		}

		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.isActive = true

		// Add a bottom dummy view to avoid bottom of presented view is off with spring animation
		let emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(emptyView)

		emptyView.backgroundColor = presentedView.backgroundColor
        emptyView.constrainTo(height: 100.0)
		if let presentedViewWidth = presentedViewWidth {
            emptyView.constrainTo(width: presentedViewWidth)
		} else {
			NSLayoutConstraint(item: emptyView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
			NSLayoutConstraint(item: emptyView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
		}
		NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: presentedView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true

		// Update layout immediately
		containerView.layoutIfNeeded()

		// Final constraints
		topConstraint.isActive = false
		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.isActive = true

		// Presenting animations
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { finished in
				emptyView.removeFromSuperview()

				transitionContext.completeTransition(finished)
			})
	}

	private func dismissingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for dismissing
		guard
			let fromView = self.fromViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}

		topConstraint.isActive = false

		topConstraint = NSLayoutConstraint(item: fromView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.isActive = true

		// Dismissing animations
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}

	public override func animationEnded(_ transitionCompleted: Bool) {
		if transitionCompleted == false {
			return
		}

		if presenting {
			// Nothing to clear for presenting
		} else {
			// Clean up for dismissing
			topConstraint = nil
		}

		// Call super.animationEnded at end to avoid clear transitionContext
		super.animationEnded(transitionCompleted)
	}
}

// MARK: - UIViewControllerTransitioningDelegate
public extension SlideUpAnimator {
    override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let overlayPresentationController = OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle)
        overlayPresentationController.shouldDismissOnTappingOutsideView = shouldDismissOnTappingOutsideView
        overlayPresentationController.shouldDimPresentedView = shouldDimPresentedView

        return overlayPresentationController
    }
}
