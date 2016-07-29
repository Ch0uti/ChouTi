//
//  SlideUpAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

public class SlideUpAnimator: Animator {
	
	public var presentedViewHeight: CGFloat = 400
	public var presentedViewWidth: CGFloat?
	
	public var overlayViewStyle: OverlayViewStyle = .Normal(UIColor(white: 0.0, alpha: 0.75))
	
	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	public var shouldDimPresentedView: Bool = false
	
	// Tap to dismiss
	public var shouldDismissOnTappingOutsideView: Bool = true
	
	private var topConstraint: NSLayoutConstraint!
	
	public override init() {
		super.init()
		animationDuration = 0.5
	}
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SlideUpAnimator {
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
			NSLayoutConstraint(item: presentedView, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: presentedView, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
		}
		
		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Add a bottom dummy view to avoid bottom of presented view is off with spring animation
		let emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(emptyView)
		
		emptyView.backgroundColor = presentedView.backgroundColor
        emptyView.constrainTo(height: 100.0)
		if let presentedViewWidth = presentedViewWidth {
            emptyView.constrainTo(width: presentedViewWidth)
		} else {
			NSLayoutConstraint(item: emptyView, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: emptyView, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
		}
		NSLayoutConstraint(item: emptyView, attribute: .Top, relatedBy: .Equal, toItem: presentedView, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		
		// Update layout immediately
		containerView.layoutIfNeeded()
		
		// Final constraints
		topConstraint.active = false
		topConstraint = NSLayoutConstraint(item: presentedView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Presenting animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { finished in
				emptyView.removeFromSuperview()
				
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
		
		topConstraint.active = false
		
		topConstraint = NSLayoutConstraint(item: fromView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		topConstraint.active = true
		
		// Dismissing animations
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
			containerView.layoutIfNeeded()
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}
	
	public override func animationEnded(transitionCompleted: Bool) {
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
    
    public override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let overlayPresentationController = OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle)
        overlayPresentationController.shouldDismissOnTappingOutsideView = shouldDismissOnTappingOutsideView
        overlayPresentationController.shouldDimPresentedView = shouldDimPresentedView
        
        return overlayPresentationController
    }
}
