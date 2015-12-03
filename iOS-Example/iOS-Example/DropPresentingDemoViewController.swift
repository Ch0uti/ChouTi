//
//  DropPresentingDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-12-03.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class DropPresentingDemoViewController: UIViewController {

	let animator = DropPresentingAnimator()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		animator.animationDuration = 0.75
		animator.shouldDismissOnTappingOutsideView = true
		animator.presentingViewSize = CGSize(width: ceil(screenWidth * 0.7), height: 160)
		animator.overlayViewStyle = .Dimmed(UIColor(white: 0.2, alpha: 1.0))
		
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		button.setBackgroundColor(UIColor.purpleColor(), forUIControlState: .Normal)
		button.setBackgroundColor(UIColor.purpleColor().colorWithAlphaComponent(0.8), forUIControlState: .Highlighted)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
		
		button.setTitle("Present!", forState: .Normal)
		button.titleLabel?.font = UIFont.systemFontOfSize(22)
		
		button.constraintToSize(CGSize(width: 160, height: 60))
		button.centerInSuperview()
		
		button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
    }
	
	func buttonTapped(sender: AnyObject) {
		let dummyViewController = UIViewController()
		dummyViewController.view.backgroundColor = UIColor(red:255/255.0, green:186/255.0, blue:1/255.0, alpha:255/255.0)
		dummyViewController.view.layer.cornerRadius = 4.0
		
		dummyViewController.view.userInteractionEnabled = true
		
		dummyViewController.modalPresentationStyle = .Custom
		dummyViewController.transitioningDelegate = animator
		
		presentViewController(dummyViewController, animated: true, completion: nil)
	}
}
