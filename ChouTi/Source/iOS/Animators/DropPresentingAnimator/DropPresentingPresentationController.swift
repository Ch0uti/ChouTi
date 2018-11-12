//
//  Created by Honghao Zhang on 04/25/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

class DropPresentingPresentationController: OverlayPresentationController {
    weak var dropPresentingAnimator: DropPresentingAnimator?

    var allowDragToDismiss: Bool = false
    var longPressGesture: UILongPressGestureRecognizer?
    var panBeginLocation: CGPoint?

    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, overlayViewStyle: OverlayViewStyle, dropPresentingAnimator: DropPresentingAnimator) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController, overlayViewStyle: overlayViewStyle)

        self.dropPresentingAnimator = dropPresentingAnimator
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        // Adding gestures to presenting view controller
        if allowDragToDismiss {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(DropPresentingPresentationController.overlayViewPanned(_:)))
            longPressGesture.minimumPressDuration = 0.1
            longPressGesture.delegate = self
            presentedView?.addGestureRecognizer(longPressGesture)
            self.longPressGesture = longPressGesture
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        panBeginLocation = nil

        super.dismissalTransitionDidEnd(completed)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DropPresentingPresentationController {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only response to long press gesture
        guard let longPressGesture = gestureRecognizer as? UILongPressGestureRecognizer, longPressGesture == self.longPressGesture else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        // If animator is nil, which makes no sense to handling gesture
        guard dropPresentingAnimator != nil else {
            return false
        }

        guard let presentedView = presentedView else {
            return true
        }

        let locationInPresentedView = gestureRecognizer.location(in: presentedView)
        if presentedView.bounds.contains(locationInPresentedView) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Actions
extension DropPresentingPresentationController {
    @objc
    func overlayViewPanned(_ sender: AnyObject) {
        guard let longPressGesture = sender as? UILongPressGestureRecognizer, longPressGesture == self.longPressGesture else {
            return
        }

        let locationInOverlayView = longPressGesture.location(in: overlayView)

        switch longPressGesture.state {
        case .began:
            panBeginLocation = locationInOverlayView
            dropPresentingAnimator?.interactive = true

            let containerHeight = containerView?.bounds.height ?? screenHeight
            let presentedViewCenterY = presentedView?.center.y ?? screenHeight / 2.0
            dropPresentingAnimator?.interactiveAnimationDraggingRange = containerHeight - presentedViewCenterY

            let locationInContainerView = longPressGesture.location(in: containerView)
            let containerWidth = containerView?.bounds.width ?? screenWidth
            let topCenter = CGPoint(x: containerWidth / 2.0, y: 0)

            let sinValue = (locationInContainerView.x - topCenter.x) / (locationInContainerView.y - topCenter.y)
            let angel = asin(sinValue).toDegrees()

            dropPresentingAnimator?.interactiveAnimationTransformAngel = angel.normalize(-30, 30)

            presentingViewController.dismiss(animated: true, completion: nil)

        case .changed:
            guard let panBeginLocation = panBeginLocation else {
                NSLog("Warning: pan begin location is nil")
                return
            }

            guard let interactiveAnimationDraggingRange = dropPresentingAnimator?.interactiveAnimationDraggingRange else {
                NSLog("Error: interactiveAnimationDraggingRange is nil")
                return
            }

            let yOffset = locationInOverlayView.y - panBeginLocation.y
            let progress = yOffset / interactiveAnimationDraggingRange

            dropPresentingAnimator?.updateInteractiveTransition(locationInOverlayView, percentComplete: progress)

        case .ended:
            guard let panBeginLocation = panBeginLocation else {
                NSLog("Warning: pan begin location is nil")
                return
            }

            guard let interactiveAnimationDraggingRange = dropPresentingAnimator?.interactiveAnimationDraggingRange else {
                NSLog("Error: interactiveAnimationDraggingRange is nil")
                return
            }

            let yOffset = locationInOverlayView.y - panBeginLocation.y
            let progress = yOffset / interactiveAnimationDraggingRange

            // If dragging speed is large enough, finish the dismiss transition
            if longPressGesture.velocityInAttachedView().y > 1_000 {
                dropPresentingAnimator?.finishInteractiveTransition(progress)
                return
            }

            if progress > 0.5 {
                dropPresentingAnimator?.finishInteractiveTransition(progress)
            } else {
                dropPresentingAnimator?.cancelInteractiveTransition(progress)
            }

        default:
            dropPresentingAnimator?.cancelInteractiveTransition(0.0)
        }
    }
}
