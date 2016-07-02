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
        
        let wrapperBaseLeadingConstraint = NSLayoutConstraint(item: dropDownMenu.wrapperView, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1.0, constant: frame.origin.x)
        wrapperBaseLeadingConstraint.priority = 800
        wrapperBaseLeadingConstraint.active = true
        
        let wrapperBaseTopConstraint = NSLayoutConstraint(item: dropDownMenu.wrapperView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1.0, constant: frame.origin.y)
        wrapperBaseTopConstraint.priority = 800
        wrapperBaseTopConstraint.active = true
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let dropDownMenu = dropDownMenu else {
            NSLog("Error: dropDownMenu is nil")
            return
        }
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition(nil, completion: { coordinatorContext in
            dropDownMenu.addSubview(dropDownMenu.wrapperView)
            dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
            dropDownMenu.setupWrapperViewConstraints()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = containerView else {
            NSLog("Error: containerView is nil")
            return CGRect.zero
        }
        
        guard let presentedView = presentedView() else {
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
    override func overlayViewTapped(tapRecognizer: UITapGestureRecognizer) {
        dropDownMenu?.set(toExpand: false, animated: true)
    }
}

// MARK: - UIContentContainer
extension DropDownMenuPresentationController {
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ [unowned self] coordinatorContext in
            self.presentedView()?.frame = self.frameOfPresentedViewInContainerView()
            }, completion: nil)
    }
}

// MARK: - Private Helper Extensions
extension UIView {
    private func switchBackgroundColorWithAnotherView(anotherView: UIView) {
        let anotherViewBackgroundColor = anotherView.backgroundColor
        anotherView.backgroundColor = backgroundColor
        backgroundColor = anotherViewBackgroundColor
    }
}
