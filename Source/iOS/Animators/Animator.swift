//
//  Animator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-16.
//
//

import UIKit

public class Animator: NSObject {
	
	// MARK: - Registering/Getting animators
	
	/**
	Customized Animation Types
	All customized animations should be registered here
	
	- LeftToRightSlide:      Slide from left to right
	- TopToBottomPresenting: Present from top to bottom
	- FadeInPresenting:      Present as fade in
	*/
	@objc public enum AnimationType: Int {
		case LeftToRightSlide = 1
		case TopToBottomPresenting = 2
		case FadeInPresenting = 3
		
		static func animatorForType(type: AnimationType) -> Animator {
			switch type {
			case .LeftToRightSlide: return LeftToRightSlideAnimator()
			case .TopToBottomPresenting: return TopToBottomPresentingAnimator()
			case .FadeInPresenting: return FadeInPresentingAnimator()
			}
		}
		
		static func animatorWithClassTypeForAnimationType(type: AnimationType) -> (Animator, AnyClass) {
			switch type {
			case .LeftToRightSlide: return (LeftToRightSlideAnimator(), LeftToRightSlideAnimator.self)
			case .TopToBottomPresenting: return (TopToBottomPresentingAnimator(), TopToBottomPresentingAnimator.self)
			case .FadeInPresenting: return (FadeInPresentingAnimator(), FadeInPresentingAnimator.self)
			}
		}
		
		static func animatorClassTypeForAnimationType(type: AnimationType) -> AnyClass {
			switch type {
			case .LeftToRightSlide: return LeftToRightSlideAnimator.self
			case .TopToBottomPresenting: return TopToBottomPresentingAnimator.self
			case .FadeInPresenting: return FadeInPresentingAnimator.self
			}
		}
	}
	
	/// Get animator for an animation type.
	/// Discussion: This method is a factory method for Animator. 
	/// You should use this method or `func animatorWithClassTypeForAnimationType(type: AnimationType) -> (Animator, AnyClass)` to create an Animator
	class public func animatorForAnimationType(type: AnimationType) -> Animator {
		return AnimationType.animatorForType(type)
	}
	
	/// Get animator along with its class type for an animation type
	/// Discussion: This method is a factory method for Animator.
	/// This method is an extended method to `func animatorForAnimationType(type: AnimationType) -> Animator`. This method returns class type for the animator. Only available in Swift.
	class public func animatorWithClassTypeForAnimationType(type: AnimationType) -> (Animator, AnyClass) {
		return AnimationType.animatorWithClassTypeForAnimationType(type)
	}
	
	
	
	// MARK: - Properties
	
	/// Animation Durations, by default, it's 0.25s
	public var animationDuration: NSTimeInterval = 0.25
	
	/// Boolean flag reflects whether it's a presenting animation or dismissing animation
	public var presenting: Bool = true
	
	/// Current transitionContext, private usage.
	private weak var transitionContext: UIViewControllerContextTransitioning?
}



// MARK: - UIViewControllerAnimatedTransitioning
extension Animator: UIViewControllerAnimatedTransitioning {
	/**
	Get duration for the transition animation
	Discussion: If you want to change the duration, just update the `animationDuration` property
	
	- parameter transitionContext: The context object containing information to use during the transition.
	
	- returns: The duration, in seconds, of your custom transition animation.
	*/
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		// Update current transitionContext
		self.transitionContext = transitionContext
		return animationDuration
	}
	
	/**
	Customized animations
	NOTE: Be sure to call super.animateTransition(transitionContext: UIViewControllerContextTransitioning)
	
	- parameter transitionContext: transitionContext
	*/
	public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		// Update current transitionContext
		self.transitionContext = transitionContext
	}
}



// MARK: - Handy Properties
extension Animator {
	
	/// fromView from current transition context
	var fromView: UIView? { return transitionContext?.viewForKey(UITransitionContextFromViewKey) }

	/// toView from current transition context
	var toView: UIView? { return transitionContext?.viewForKey(UITransitionContextToViewKey) }
	
	/// containerView from current transition context
	var containerView: UIView? { return transitionContext?.containerView() }
	
	/// presentedView, which is the toView in presenting and the fromView in dismissing
	var presentedView: UIView? { return presenting ? toView : fromView }
	
	/// presentingView, which is the fromView in presenting and the toView in dismissing
	var presentingView: UIView? { return presenting ? fromView : toView }
	
	/// fromViewController from current transition context
	var fromViewController: UIViewController? {
		return transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
	}
	
	/// toViewController from current transition context
	var toViewController: UIViewController? {
		return transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
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
