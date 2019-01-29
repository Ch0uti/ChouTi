// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

/**
 Overlay View Style

 - Normal:  This is a normal overlay view with a customized background color
 - Blurred: This is blurred overlay view with blur effect style and background color
 */
public enum OverlayViewStyle {
    case normal(UIColor)
    case blurred(UIBlurEffect.Style, UIColor)
}

/// Base Overlay Presentation Controller
open class OverlayPresentationController: UIPresentationController {
    /// Whether should dismiss presented view when tap out side of presented view
    open var shouldDismissOnTappingOutsideView: Bool = true

    /// Whether presenting view should be dimmed when preseting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
    open var shouldDimPresentedView: Bool = false

    // MARK: - OverlayView

    lazy var overlayView: UIView = {
        let overlayView: UIView
        switch self.overlayViewStyle {
        case let .blurred(style, color):
            overlayView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            overlayView.backgroundColor = color
        case let .normal(color):
            overlayView = UIView()
            overlayView.backgroundColor = color
        }

        return overlayView
    }()

    open var overlayViewStyle: OverlayViewStyle = .blurred(.dark, UIColor(white: 0.0, alpha: 0.5))

    // MARK: - Private

    private var dismissTapGesture: UITapGestureRecognizer?

    // MARK: - Init Methods

    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, overlayViewStyle: OverlayViewStyle) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        self.overlayViewStyle = overlayViewStyle
    }

    // MARK: - Transition

    open override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return
        }

        if shouldDimPresentedView {
            presentingViewController.view.tintAdjustmentMode = .dimmed
        }

        // Setup tap gesture
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(OverlayPresentationController.overlayViewTapped(_:)))
        overlayView.addGestureRecognizer(dismissTapGesture)
        dismissTapGesture.delegate = self
        self.dismissTapGesture = dismissTapGesture

        // Update overlay view
        overlayView.frame = containerView.bounds
        overlayView.alpha = 0.0

        containerView.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 1.0
        }, completion: nil)
    }

    open override func dismissalTransitionWillBegin() {
        if shouldDimPresentedView {
            presentingViewController.view.tintAdjustmentMode = .normal
        }

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] coordinatorContext in
            if coordinatorContext.initiallyInteractive {
                return
            }

            self.overlayView.alpha = 0.0
        }, completion: { [unowned self] coordinatorContext in
            if coordinatorContext.initiallyInteractive {
                return
            }

            self.overlayView.removeFromSuperview()
        })

        presentingViewController.transitionCoordinator?.notifyWhenInteractionChanges({ [unowned self] coordinatorContext in
            if coordinatorContext.isCancelled == false {
                let restPercent = Double(1.0 - coordinatorContext.percentComplete)
                let restDuration = restPercent * coordinatorContext.transitionDuration

                UIView.animate(withDuration: restDuration, animations: { [weak self] in
                    self?.overlayView.alpha = 0.0
                }, completion: { [weak self] _ in
                    self?.overlayView.removeFromSuperview()
                })
            }
        })
    }

    // MARK: - Layout of the Presentation

    open override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return
        }

        overlayView.frame = containerView.bounds
    }
}

// MARK: - UIGestureRecognizerDelegate

extension OverlayPresentationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only check for self.dismissTapGesture
        guard let tapGesture = gestureRecognizer as? UITapGestureRecognizer, tapGesture == dismissTapGesture else {
            return true
        }

        if shouldDismissOnTappingOutsideView == false {
            return false
        }

        guard let presentedView = presentedView else {
            return true
        }

        // Disable tap action for presented view area
        let locationInPresentedView = gestureRecognizer.location(in: presentedView)
        if presentedView.bounds.contains(locationInPresentedView) {
            return false
        } else {
            return true
        }
    }
}

// MARK: - Actions

extension OverlayPresentationController {
    @objc
    func overlayViewTapped(_: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
