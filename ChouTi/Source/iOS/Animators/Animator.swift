//
//  Animator.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-16.
//  Copyright © 2018 ChouTi. All rights reserved.
//

// Sample Usage:
//    <#presentedViewController#>.modalPresentationStyle = .Custom
//    <#presentedViewController#>.transitioningDelegate = animator
//
//    presentViewController(<#presentedViewController#>, animated: true, completion: nil)

import UIKit

open class Animator: NSObject {
	/// Animation Durations, by default, it's 0.25s
	open var animationDuration: TimeInterval = 0.25

	/// Boolean flag reflects whether it's a presenting animation or dismissing animation
	open var presenting: Bool = true

	/// Boolean flag reflects whether the animation is interactive
	open var interactive: Bool = false

	/// Current transitionContext, private usage.
	weak var transitionContext: UIViewControllerContextTransitioning?
}

// MARK: - UIViewControllerAnimatedTransitioning
extension Animator: UIViewControllerAnimatedTransitioning {
	/**
	Get duration for the transition animation
	Discussion: If you want to change the duration, just update the `animationDuration` property
	
	- parameter transitionContext: The context object containing information to use during the transition.
	
	- returns: The duration, in seconds, of your custom transition animation.
	*/
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		self.transitionContext = transitionContext
		return animationDuration
	}

	/**
	Customized animations
	NOTE: Be sure to call super.animateTransition(transitionContext: UIViewControllerContextTransitioning)
	
	- parameter transitionContext: transitionContext
	*/
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		self.transitionContext = transitionContext
	}

	public func animationEnded(_ transitionCompleted: Bool) {
        interactive = false
        transitionContext = nil
	}
}

// MARK: - UIViewControllerInteractiveTransitioning
extension Animator: UIViewControllerInteractiveTransitioning {
	public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
		self.transitionContext = transitionContext
	}
}

// MARK: - Handy Properties
extension Animator {

	/// fromView from current transition context
	var fromView: UIView? { return transitionContext?.view(forKey: UITransitionContextViewKey.from) }

	/// toView from current transition context
	var toView: UIView? { return transitionContext?.view(forKey: UITransitionContextViewKey.to) }

	/// containerView from current transition context
	var containerView: UIView? { return transitionContext?.containerView }

	/// presentedView, which is the toView in presenting and the fromView in dismissing
	var presentedView: UIView? { return presenting ? toView : fromView }

	/// presentingView, which is the fromView in presenting and the toView in dismissing
	var presentingView: UIView? { return presenting ? fromView : toView }

	/// fromViewController from current transition context
	var fromViewController: UIViewController? {
		return transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
	}

	/// toViewController from current transition context
	var toViewController: UIViewController? {
		return transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)
	}

	/// presentedViewController, which is the toViewController in presenting and the fromViewController in dismissing
	var presentedViewController: UIViewController? {
		return presenting ? toViewController : fromViewController
	}

	/// presentingViewController, which is the fromViewController in presenting and the toViewController in dismissing
	var presentingViewController: UIViewController? {
		return presenting ? fromViewController : toViewController
	}
}

// MARK: - UIViewControllerTransitioningDelegate
extension Animator: UIViewControllerTransitioningDelegate {
    // MARK: - Getting the Transition Animator Objects
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = true
		return self
	}

	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = false
		return self
	}

    // MARK: - Getting the Interactive Animator Objects
	public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		self.presenting = true
		return interactive ? self : nil
	}

	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		self.presenting = false
		return interactive ? self : nil
	}

    // MARK: - Getting the Custom Presentation Controller
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
}
