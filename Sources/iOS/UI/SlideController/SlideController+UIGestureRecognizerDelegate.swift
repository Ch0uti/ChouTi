// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

extension SlideController: UIGestureRecognizerDelegate {
    @objc
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            switch state {
            case .notExpanded:
                // If going to expand
                showShadowForCenterViewController(true)
                let velocity = recognizer.velocity(in: view)
                if velocity.x > 0, leftViewController != nil {
                    // Show left
                    beginViewController(leftViewController, appearanceTransition: true, animated: true)
                    state = .leftExpanding
                    beginViewController(centerViewController, appearanceTransition: false, animated: true)
                } else if velocity.x < 0, rightViewController != nil {
                    // Show right
                    beginViewController(rightViewController, appearanceTransition: true, animated: true)
                    state = .rightExpanding
                    beginViewController(centerViewController, appearanceTransition: false, animated: true)
                }

            case .leftExpanded:
                // If going to collapse from left
                beginViewController(leftViewController, appearanceTransition: false, animated: true)
                state = .leftCollapsing
                beginViewController(centerViewController, appearanceTransition: true, animated: true)

            case .rightExpanded:
                // If going to collapse from right
                beginViewController(rightViewController, appearanceTransition: false, animated: true)
                state = .rightCollapsing
                beginViewController(centerViewController, appearanceTransition: true, animated: true)

            default:
                assertionFailure()
            }
        case .changed:
            let centerX = view.bounds.width / 2.0
            let centerXToBe = recognizer.view!.center.x + recognizer.translation(in: view).x

            if recognizer.view!.center.x > centerX {
                // Showing left

                // If there's no left view controller, no need for vc configuration
                if leftViewController == nil {
                    recognizer.setTranslation(CGPoint.zero, in: view)
                    return
                }

                if !leftViewControllerAdded {
                    replaceViewController(rightViewController, withViewController: leftViewController)
                    rightViewControllerAdded = false
                    leftViewControllerAdded = true
                }

                statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (leftRevealWidth ?? revealWidth), 1.0))

                // If revealed width is greater than reveal width set, stop it
                if shouldExceedRevealWidth == false, (centerXToBe - centerX >= leftRevealWidth ?? revealWidth) {
                    recognizer.view!.center.x = centerX + (leftRevealWidth ?? revealWidth)
                    recognizer.setTranslation(CGPoint.zero, in: view)
                    return
                }

            } else if recognizer.view!.center.x < centerX {
                // Showing right
                if rightViewController == nil {
                    recognizer.setTranslation(CGPoint.zero, in: view)
                    return
                }
                if !rightViewControllerAdded {
                    replaceViewController(leftViewController, withViewController: rightViewController)
                    leftViewControllerAdded = false
                    rightViewControllerAdded = true
                }

                statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(min(abs(recognizer.view!.center.x - centerX) / (rightRevealWidth ?? revealWidth), 1.0))

                if shouldExceedRevealWidth == false, (centerX - centerXToBe >= rightRevealWidth ?? revealWidth) {
                    recognizer.view!.center.x = centerX - (rightRevealWidth ?? revealWidth)
                    recognizer.setTranslation(CGPoint.zero, in: view)
                    return
                }
            }

            // If resultCenterX is invalid, stop
            if (leftViewController == nil && centerXToBe >= centerX) || (rightViewController == nil && centerXToBe <= centerX) {
                recognizer.view!.center.x = centerX
                recognizer.setTranslation(CGPoint.zero, in: view)
                statusBarBackgroundView.backgroundColor = statusBarBackgroundColor?.withAlphaComponent(0)
                return
            }

            recognizer.view!.center.x = centerXToBe
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            let velocity = recognizer.velocity(in: view)
            if velocity.x > 500.0 {
                // To right, fast enough
                if leftViewControllerAdded {
                    animateLeftViewControllerShouldExpand(true) { [unowned self] _ in
                        self.endViewControllerAppearanceTransition(self.leftViewController)
                        self.endViewControllerAppearanceTransition(self.centerViewController)
                    }
                } else {
                    fallthrough
                }
            } else if velocity.x < -500.0 {
                // To left, fast enough
                if rightViewControllerAdded {
                    animateRightViewControllerShouldExpand(true) { [unowned self] _ in
                        self.endViewControllerAppearanceTransition(self.rightViewController)
                        self.endViewControllerAppearanceTransition(self.centerViewController)
                    }
                } else {
                    fallthrough
                }
            } else {
                // Slow, check half position to determine whether show or not
                if recognizer.view!.center.x > view.bounds.width {
                    // Showing left
                    switch state {
                    case .leftCollapsing:
                        beginViewController(leftViewController, appearanceTransition: true, animated: true)
                        beginViewController(centerViewController, appearanceTransition: false, animated: true)
                    default:
                        break
                    }
                    animateLeftViewControllerShouldExpand(true) { [unowned self] _ in
                        self.endViewControllerAppearanceTransition(self.leftViewController)
                        self.endViewControllerAppearanceTransition(self.centerViewController)
                    }
                } else if recognizer.view!.center.x < 0 {
                    // Showing right
                    switch state {
                    case .rightCollapsing:
                        beginViewController(rightViewController, appearanceTransition: true, animated: true)
                        beginViewController(centerViewController, appearanceTransition: false, animated: true)
                    default:
                        break
                    }
                    animateRightViewControllerShouldExpand(true) { [unowned self] _ in
                        self.endViewControllerAppearanceTransition(self.rightViewController)
                        self.endViewControllerAppearanceTransition(self.centerViewController)
                    }
                } else {
                    // Showing center
                    fallthrough
                }
            }
        default:
            switch state {
            case .leftExpanding:
                beginViewController(leftViewController, appearanceTransition: false, animated: true)
                beginViewController(centerViewController, appearanceTransition: true, animated: true)

            case .rightExpanding:
                beginViewController(rightViewController, appearanceTransition: false, animated: true)
                beginViewController(centerViewController, appearanceTransition: true, animated: true)

            default:
                break
            }

            animateCenterViewController({ [unowned self] _ in
                switch self.state {
                case .leftExpanding, .leftCollapsing:
                    self.endViewControllerAppearanceTransition(self.leftViewController)
                    self.endViewControllerAppearanceTransition(self.centerViewController)
                case .rightExpanding, .rightCollapsing:
                    self.endViewControllerAppearanceTransition(self.rightViewController)
                    self.endViewControllerAppearanceTransition(self.centerViewController)
                default:
                    break
                }
            })
        }
    }

    @objc
    func handleTapGesture(_: UITapGestureRecognizer) {
        // Tap center view controller to collapse
        if state != .notExpanded {
            collapse()
        }
    }
}

public extension SlideController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // If one side view controller is nil, stop to reveal it
        if gestureRecognizer == panGestureRecognizer {
            if state == .notExpanded {
                if panGestureRecognizer.velocity(in: view).x > 0 {
                    return leftViewController != nil
                } else if panGestureRecognizer.velocity(in: view).x < 0 {
                    return rightViewController != nil
                }
            }
        }

        return true
    }
}

extension SlideController {
    func animateLeftViewControllerShouldExpand(_ shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        if shouldExpand {
            replaceViewController(rightViewController, withViewController: leftViewController)
            rightViewControllerAdded = false
            leftViewControllerAdded = true

            state = .leftExpanding
            animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, completion: { [unowned self] finished -> Void in
                self.leftViewController?.didMove(toParent: self)
                self.state = .leftExpanded
                completion?(finished)
            })
        } else {
            state = .leftCollapsing
            animateCenterViewController({ finished in
                completion?(finished)
            })
        }
    }

    func animateRightViewControllerShouldExpand(_ shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        if shouldExpand {
            replaceViewController(leftViewController, withViewController: rightViewController)
            leftViewControllerAdded = false
            rightViewControllerAdded = true

            state = .rightExpanding
            animateCenterViewControllerWithXOffset(-(rightRevealWidth ?? revealWidth), completion: { [unowned self] finished -> Void in
                self.rightViewController?.didMove(toParent: self)
                self.state = .rightExpanded
                completion?(finished)
            })
        } else {
            state = .rightCollapsing
            animateCenterViewController({ finished in
                completion?(finished)
            })
        }
    }

    /// Go to state .NotExpanded
    func animateCenterViewController(_ completion: ((Bool) -> Void)? = nil) {
        animateCenterViewControllerWithXOffset(0.0, completion: { [unowned self] finished -> Void in
            switch self.state {
            case .leftExpanding, .leftExpanded:
                self.removeViewController(self.leftViewController!)
                self.leftViewControllerAdded = false
            case .rightExpanding, .rightExpanded:
                self.removeViewController(self.rightViewController!)
                self.rightViewControllerAdded = false
            default:
                break
            }
            completion?(finished)
            self.state = .notExpanded
        })
    }

    func animateCenterViewControllerWithXOffset(_ xOffset: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        let animationClosure: () -> Void = { [unowned self] in
            self.centerViewController.view.center = CGPoint(x: self.view.center.x + xOffset, y: self.centerViewController.view.center.y)
            self.centerViewController.view.frame.origin.y = 0
            self.statusBarBackgroundView.backgroundColor = self.statusBarBackgroundColor?.withAlphaComponent(abs(xOffset) / (xOffset > 0 ? (self.leftRevealWidth ?? self.revealWidth) : (self.rightRevealWidth ?? self.revealWidth)))
            self.isAnimating = false
        }

        if !animated {
            animationClosure()
            completion?(true)
            return
        }

        if let springDampin = springDampin, let initialSpringVelocity = initialSpringVelocity, shouldExceedRevealWidth == true {
            isAnimating = true
            UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDampin, initialSpringVelocity: initialSpringVelocity, options: [.beginFromCurrentState, .curveEaseInOut], animations: animationClosure, completion: completion)
        } else {
            isAnimating = true
            UIView.animate(withDuration: animationDuration, animations: animationClosure, completion: completion)
        }
    }
}
