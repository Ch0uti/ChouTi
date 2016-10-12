//
//  OverlayPresentationController.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-02-23.
//
//

import UIKit

/**
 Overlay View Style
 
 - Normal:  This is a normal overlay view with a customized background color
 - Blurred: This is blurred overlay view with blur effect style and background color
 */
public enum OverlayViewStyle {
    case Normal(UIColor)
    case Blurred(UIBlurEffectStyle, UIColor)
}

/// Base Overlay Presentation Controller
public class OverlayPresentationController: UIPresentationController {
    
    /// Whether should dismiss presented view when tap out side of presented view
    public var shouldDismissOnTappingOutsideView: Bool = true
    
    /// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
    public var shouldDimPresentedView: Bool = false
    
    // MARK: - OverlayView
    lazy var overlayView: UIView = {
        let overlayView: UIView
        switch self.overlayViewStyle {
        case .Blurred(let style, let color):
            overlayView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            overlayView.backgroundColor = color
        case .Normal(let color):
            overlayView = UIView()
            overlayView.backgroundColor = color
        }
        
        return overlayView
    }()
    
    public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.5))
    
    // MARK: - Private
    private var dismissTapGesture: UITapGestureRecognizer?
    
    // MARK: - Init Methods
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, overlayViewStyle: OverlayViewStyle) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        self.overlayViewStyle = overlayViewStyle
    }
    
    // MARK: - Transition
    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return
        }
        
        if shouldDimPresentedView {
            presentingViewController.view.tintAdjustmentMode = .Dimmed
        }
        
        // Setup tap gesture
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(OverlayPresentationController.overlayViewTapped(_:)))
        overlayView.addGestureRecognizer(dismissTapGesture)
        dismissTapGesture.delegate = self
        self.dismissTapGesture = dismissTapGesture
        
        // Update overlay view
        overlayView.frame = containerView.bounds
        overlayView.alpha = 0.0
        
        containerView.insertSubview(overlayView, atIndex: 0)
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [unowned self] coordinatorContext in
            self.overlayView.alpha = 1.0
        }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        if shouldDimPresentedView {
            presentingViewController.view.tintAdjustmentMode = .Normal
        }
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [unowned self] coordinatorContext in
            if coordinatorContext.initiallyInteractive() {
                return
            }
            
            self.overlayView.alpha = 0.0
        }, completion: { [unowned self] coordinatorContext in
            if coordinatorContext.initiallyInteractive() {
                return
            }
            
            self.overlayView.removeFromSuperview()
        })
        
        presentingViewController.transitionCoordinator()?.notifyWhenInteractionEndsUsingBlock({ [unowned self] (coordinatorContext) in
            coordinatorContext.completionVelocity()
            if coordinatorContext.isCancelled() == false {
                let restPercent = Double(1.0 - coordinatorContext.percentComplete())
                let restDuration = restPercent * coordinatorContext.transitionDuration()
                
                UIView.animateWithDuration(restDuration, animations: { [weak self] in
                    self?.overlayView.alpha = 0.0
                }, completion: { [weak self] finished in
                    self?.overlayView.removeFromSuperview()
                })
            }
        })
    }
    
    // MARK: - Layout of the Presentation
    public override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return
        }
        
        overlayView.frame = containerView.bounds
    }
}


// MARK: - UIGestureRecognizerDelegate
extension OverlayPresentationController : UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only check for self.dismissTapGesture
        guard let tapGesture = gestureRecognizer as? UITapGestureRecognizer where tapGesture == dismissTapGesture else {
            return true
        }
        
        if shouldDismissOnTappingOutsideView == false {
            return false
        }
        
        guard let presentedView = presentedView() else {
            return true
        }
        
        // Disable tap action for presented view area
        let locationInPresentedView = gestureRecognizer.locationInView(presentedView)
        if presentedView.bounds.contains(locationInPresentedView) {
            return false
        } else {
            return true
        }
    }
}

// MARK: - Actions
extension OverlayPresentationController {
    func overlayViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
