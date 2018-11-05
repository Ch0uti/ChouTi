//
//  DropDownMenuPresentationController.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-02-23.
//
//

import UIKit

class DropDownMenuPresentationController: OverlayPresentationController {

    weak var dropDownMenu: DropDownMenu?

    // MARK: - Transition
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return
        }

        guard let dropDownMenu = dropDownMenu else {
            NSLog("Error: dropDownMenu is nil")
            return
        }

        containerView.addSubview(dropDownMenu.wrapperView)
        dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
        dropDownMenu.setupWrapperViewConstraints()

        // Setup additional base leading/top constaint, this is used for keeping wrapper view same position when dropdown menu is removed somehow
        // Note: wrapper view size alraedy has base constraints
        let frame = dropDownMenu.frameRectInView(containerView)

        let wrapperBaseLeadingConstraint = NSLayoutConstraint(item: dropDownMenu.wrapperView, attribute: .leading,
                                                              relatedBy: .equal,
                                                              toItem: containerView, attribute: .leading,
                                                              multiplier: 1.0, constant: frame.origin.x)
        wrapperBaseLeadingConstraint.priority = UILayoutPriority(800)
        wrapperBaseLeadingConstraint.isActive = true

        let wrapperBaseTopConstraint = NSLayoutConstraint(item: dropDownMenu.wrapperView, attribute: .top,
                                                          relatedBy: .equal,
                                                          toItem: containerView, attribute: .top,
                                                          multiplier: 1.0, constant: frame.origin.y)
        wrapperBaseTopConstraint.priority = UILayoutPriority(800)
        wrapperBaseTopConstraint.isActive = true
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        guard let dropDownMenu = dropDownMenu else {
            NSLog("Error: dropDownMenu is nil")
            return
        }

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: nil, completion: { _ in
            dropDownMenu.addSubview(dropDownMenu.wrapperView)
            dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
            dropDownMenu.setupWrapperViewConstraints()
        })
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return CGRect.zero
        }

        guard let presentedView = presentedView else {
            NSLog("Error: presentedView() is nil")
            return CGRect.zero
        }

        guard let dropDownMenu = dropDownMenu else {
            NSLog("Error: dropDownMenu is nil")
            return presentedView.frame
        }

		let menuFrame = dropDownMenu.frameRectInView(containerView)
        return CGRect(x: menuFrame.left, y: menuFrame.bottom, width: menuFrame.width, height: containerView.height - menuFrame.bottom)
    }
}

// MARK: - Actions
extension DropDownMenuPresentationController {
    override func overlayViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        dropDownMenu?.set(toExpand: false, animated: true)
    }
}

// MARK: - UIContentContainer
extension DropDownMenuPresentationController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            }, completion: nil)
    }
}

// MARK: - Private Helper Extensions
private extension UIView {
    func switchBackgroundColorWithAnotherView(_ anotherView: UIView) {
        let anotherViewBackgroundColor = anotherView.backgroundColor
        anotherView.backgroundColor = backgroundColor
        backgroundColor = anotherViewBackgroundColor
    }
}
