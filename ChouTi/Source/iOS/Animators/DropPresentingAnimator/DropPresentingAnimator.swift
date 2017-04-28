//
//  DropPresentingAnimator.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/29/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

// Sample Usage:
//let <#animator#> = DropPresentingAnimator()
//
//<#animator#>.animationDuration = 0.75
//<#animator#>.shouldDismissOnTappingOutsideView = true
//<#animator#>.presentingViewSize = CGSize(width: ceil(screenWidth * 0.7), height: 160)
//<#animator#>.overlayViewStyle = .Blurred(UIColor(white: 0.2, alpha: 1.0))
//
//<#presentedViewController#>.modalPresentationStyle = .Custom
//<#presentedViewController#>.transitioningDelegate = animator
//
//presentViewController(<#presentedViewController#>, animated: true, completion: nil)

import UIKit

open class DropPresentingAnimator: Animator {
	
	public override init() {
		super.init()
		animationDuration = 0.5
	}
	
    open var presentingViewSize = CGSize(width: 300, height: 200)
	
	open var overlayViewStyle: OverlayViewStyle = .blurred(.dark, UIColor(white: 0.0, alpha: 0.85))
	
	/// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	open var shouldDimPresentedView: Bool = false
	
	// Tap to dismiss
	open var shouldDismissOnTappingOutsideView: Bool = true
	
	// Drag to dismiss (interactive)
	open var allowDragToDismiss: Bool = false
	
	// MARK: - Private
    fileprivate weak var presentationController: DropPresentingPresentationController?
	var interactiveAnimationDraggingRange: CGFloat?
	var interactiveAnimationTransformAngel: CGFloat?
}



// MARK: - UIViewControllerAnimatedTransitioning
extension DropPresentingAnimator {
	public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		super.animateTransition(using: transitionContext)
		
		if presenting {
			presentingAnimation(transitionContext)
		} else {
			dismissingAnimation(transitionContext, percentComplete: 0.0)
		}
	}
	
	fileprivate func presentingAnimation(_ transitionContext: UIViewControllerContextTransitioning?) {
		// Necessary setup for presenting
		guard let transitionContext = transitionContext else {
			NSLog("Error: transitionContext is nil")
			return
		}
		
		guard
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		presentedView.bounds = CGRect(origin: CGPoint.zero, size: presentingViewSize)
		presentedView.center = CGPoint(x: containerView.bounds.width / 2.0, y: 0 - presentingViewSize.height / 2.0)
		presentedView.transform = CGAffineTransform(rotationAngle: (CGFloat.random(-15, 15) * CGFloat.pi) / 180.0)
		
		containerView.addSubview(presentedView)
        
		// Presenting animations
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
			presentedView.center = containerView.center
			presentedView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat.pi) / 180.0)
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}
	
	fileprivate func dismissingAnimation(_ transitionContext: UIViewControllerContextTransitioning?, percentComplete: CGFloat) {
		// Necessary setup for dismissing
		guard let transitionContext = transitionContext else {
			NSLog("Error: transitionContext is nil")
			return
		}
		
		guard
			let fromView = self.fromViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		// Dismissing animations
		UIView.animate(withDuration: animationDuration * Double(1.0 - percentComplete), delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
			fromView.center = CGPoint(x: containerView.bounds.width / 2.0, y: containerView.bounds.height + self.presentingViewSize.height)
			fromView.transform = CGAffineTransform(rotationAngle: (self.interactiveAnimationTransformAngel ?? CGFloat.random(-15, 15) * CGFloat.pi) / 180.0)
			}, completion: { finished -> Void in
				transitionContext.completeTransition(finished)
		})
	}
	
	public override func animationEnded(_ transitionCompleted: Bool) {
		interactiveAnimationDraggingRange = nil
		interactiveAnimationTransformAngel = nil
		
		// Call super.animationEnded at end to avoid clear transitionContext
		super.animationEnded(transitionCompleted)
	}
}

// MARK: - UIViewControllerInteractiveTransitioning
extension DropPresentingAnimator {
    // MARK: - Interactive Animations
    func updateInteractiveTransition(_ draggingLocation: CGPoint, percentComplete: CGFloat) {
        if transitionContext == nil {
            NSLog("Error: transitionContext is nil")
        }
        
        self.transitionContext?.updateInteractiveTransition(percentComplete)
        guard let panBeginLocation = presentationController?.panBeginLocation else {
            NSLog("Error: pan begin location is nil")
            return
        }
        
        guard
            let fromView = self.fromViewController?.view,
            let containerView = self.containerView else {
                NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
                return
        }
        
        guard let interactiveAnimationTransformAngel = interactiveAnimationTransformAngel else {
            NSLog("Error: interactiveAnimationTransformAngel is nil")
            return
        }
        
        let yOffset = draggingLocation.y - panBeginLocation.y
        let beginPoint = containerView.center
        
        fromView.center = CGPoint(x: beginPoint.x, y: beginPoint.y + yOffset)
        fromView.transform = CGAffineTransform(rotationAngle: interactiveAnimationTransformAngel.toRadians() *  percentComplete)
    }
    
    func cancelInteractiveTransition(_ percentComplete: CGFloat) {
        if transitionContext == nil {
            NSLog("Error: transitionContext is nil")
        }
        
        transitionContext?.cancelInteractiveTransition()
        
        if presenting {
            // If cancel presenting, which will dismiss
            presentedViewController?.beginAppearanceTransition(false, animated: true)
        } else {
            // If cancel dismissing, which will present
            presentedViewController?.beginAppearanceTransition(true, animated: true)
        }
        
        guard
            let presentedView = self.presentedViewController?.view,
            let containerView = self.containerView else {
                NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
                return
        }
        
        // Set a minimum duration, at least has 20% of animation duration.
        let duration = (animationDuration * Double(percentComplete)).normalize(animationDuration * 0.2, animationDuration)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: CGFloat.random(0.55, 0.8), initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            presentedView.center = containerView.center
            presentedView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat.pi) / 180.0)
        }, completion: { [weak self] finished in
            self?.presentedViewController?.endAppearanceTransition()
            self?.transitionContext?.completeTransition(false)
        })
    }
    
    func finishInteractiveTransition(_ percentComplete: CGFloat) {
        if transitionContext == nil {
            NSLog("Warning: transitionContext is nil")
        }
        
        self.transitionContext?.finishInteractiveTransition()
        
        // Set percentage completed to less than 1.0 to give a minimum duration
        dismissingAnimation(transitionContext, percentComplete: percentComplete.normalize(0.0, 0.8))
    }
}

extension DropPresentingAnimator {
    public override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DropPresentingPresentationController(presentedViewController: presented, presentingViewController: presenting, overlayViewStyle: overlayViewStyle, dropPresentingAnimator: self)
        presentationController.shouldDismissOnTappingOutsideView = shouldDismissOnTappingOutsideView
        presentationController.shouldDimPresentedView = shouldDimPresentedView
        presentationController.allowDragToDismiss = allowDragToDismiss
        
        self.presentationController = presentationController
        
        return presentationController
    }
}
