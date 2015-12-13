//
//  DropDownMenuAnimator.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-03.
//
//

import UIKit

class DropDownMenuAnimator: Animator {
	
	override init() {
		super.init()
		animationDuration = 0.5
	}
	
	var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.5))
	
	/// Whether presenting view should be dimmed when presenting. If true, tintAdjustmentMode of presenting view will update to .Dimmed.
	var shouldDimPresentedView: Bool = false
	
	/// View key for transparent overlay view, this transparent view is used for floating menu view
	struct TransparentOverlayViewKey {
		static var Key = "zhTransparentOverlayViewKey"
	}
	
	// Tap to dismiss
	var shouldDismissOnTappingOutsideView: Bool = true
	private weak var dismissTapGesture: UITapGestureRecognizer?
	private weak var currentPresentedViewController: UIViewController?
	
	// Drop Down Menu Related
	weak var dropDownMenu: DropDownMenu?
	
	override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
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
			let presentingView = self.presentingViewController?.view,
			let presentedView = self.presentedViewController?.view,
			let containerView = self.containerView else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		guard let dropDownMenu = dropDownMenu else {
			NSLog("Error: dropDownMenu is nil")
			return
		}
		
		// Begining settings
		if shouldDimPresentedView {
			presentingView.tintAdjustmentMode = .Dimmed
		}
		
		let menuFrame = dropDownMenu.frameRectInView(containerView)
		presentedView.frame = CGRect(x: menuFrame.leading, y: menuFrame.bottom, width: menuFrame.width, height: containerView.height - menuFrame.bottom)
		containerView.addSubview(presentedView)
		
		// Add darker overlay view
		switch overlayViewStyle {
		case .Blurred(let style, let color):
			presentingView.addBlurredOverlayView(animated: true, duration: animationDuration, blurEffectStyle: style, blurredViewBackgroundColor: color)
		case .Normal(let color):
			presentingView.addOverlayView(animated: true, duration: animationDuration, overlayViewBackgroundColor: color)
		}
		
		// Add a transparent overlay view, this view is used for floating menu view
		let transparentOverlayView = presentingView.addOverlayView(animated: false, overlayViewBackgroundColor: UIColor.clearColor(), viewKeyPointer: &TransparentOverlayViewKey.Key)
		
		// Keep menu view at the top (dropDownMenu.wrapperView is the containerView for all subviews)
		transparentOverlayView.addSubview(dropDownMenu.wrapperView)
		dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
		dropDownMenu.setupWrapperViewConstraints()
		
		// Presenting animations
		presentedView.alpha = 0.999999 // presentedView.alpha is set to 1.0 in following animation block. This is make sure animation has duration
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
			presentedView.alpha = 1.0
			}, completion: { finished -> Void in
				if let presentedViewController = self.presentedViewController where self.shouldDismissOnTappingOutsideView {
					if let window = presentedViewController.view.window {
						self.currentPresentedViewController = presentedViewController
						let tapGesture = UITapGestureRecognizer(target: self, action: "outsideViewTapped:")
						tapGesture.delegate = self
						window.addGestureRecognizer(tapGesture)
						self.dismissTapGesture = tapGesture
					}
				}
				
				transitionContext.completeTransition(true)
		})
	}
	
	private func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning) {
		// Necessary setup for dismissing
		guard
			let fromView = self.fromViewController?.view,
			let toView = self.toViewController?.view else {
				NSLog("Error: Cannot get view from UIViewControllerContextTransitioning")
				return
		}
		
		guard let dropDownMenu = dropDownMenu else {
			NSLog("Error: dropDownMenu is nil")
			return
		}
		
		// Begining settings
		if shouldDimPresentedView {
			toView.tintAdjustmentMode = .Normal
		}
		
		// Restore menu wrapper view closure
		let restoreMenu = {
			dropDownMenu.addSubview(dropDownMenu.wrapperView)
			dropDownMenu.switchBackgroundColorWithAnotherView(dropDownMenu.wrapperView)
			dropDownMenu.setupWrapperViewConstraints()
			toView.removeOverlayView(animated: false, viewKeyPointer: &TransparentOverlayViewKey.Key)
		}
		
		// Remove overlay view
		switch overlayViewStyle {
		case .Blurred:
			toView.removeBlurredOverlayView(animated: true, duration: animationDuration, completion: { _ in
				restoreMenu()
			})
		case .Normal:
			toView.removeOverlayView(animated: true, duration: animationDuration, completion: { _ in
				restoreMenu()
			})
		}
		
		fromView.alpha = 0.999999
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: { () -> Void in
			fromView.alpha = 1.0
			}, completion: { finished -> Void in
				transitionContext.completeTransition(true)
		})
	}
	
	override func animationEnded(transitionCompleted: Bool) {		
		if transitionCompleted == false {
			return
		}
		
		if presenting {
			// Nothing to clear for presenting
		} else {
			// Clean up for dismissing
			
			// Clean up gestures
			if let tapGesture = self.dismissTapGesture {
				presentingViewController?.view.window?.removeGestureRecognizer(tapGesture)
			}
			dismissTapGesture = nil
			
			currentPresentedViewController = nil
		}
		
		// Call super.animationEnded at end to avoid clear transitionContext
		super.animationEnded(transitionCompleted)
	}
}

extension DropDownMenuAnimator : UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let currentPresentedViewController = self.currentPresentedViewController else {
			print("Warning: currentPresentedViewController is nil")
			return true
		}
		
		guard let dropDownMenuPickerViewController = currentPresentedViewController as? DropDownMenuPickerViewController else {
			print("Warning: currentPresentedViewController is not DropDownMenuPickerViewController")
			return true
		}
		
		// Disable tap action for option table view
		let locationInOptionTableView = gestureRecognizer.locationInView(dropDownMenuPickerViewController.tableView)
		if dropDownMenuPickerViewController.tableView.bounds.contains(locationInOptionTableView) {
			return false
		} else {
			return true
		}
	}
}

extension DropDownMenuAnimator {
	func dismisscurrentPresentedViewController() {
		outsideViewTapped(dismissTapGesture)
	}
	
	func outsideViewTapped(sender: AnyObject?) {
		if let dismissTapGesture = self.dismissTapGesture {
			currentPresentedViewController?.view.window?.removeGestureRecognizer(dismissTapGesture)
		}
		currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
