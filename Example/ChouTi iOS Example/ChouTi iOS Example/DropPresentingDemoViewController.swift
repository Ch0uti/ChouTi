//
//  DropPresentingDemoViewController.swift
//  ChouTi iOS Example
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
		animator.overlayViewStyle = .Normal(UIColor(white: 0.0, alpha: 0.85))
		
		let button = Button()
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		button.setBackgroundImageWithColor(UIColor.redColor(), forState: .Normal)
		button.setBackgroundImageWithColor(UIColor.redColor().colorWithAlphaComponent(0.8), forState: .Highlighted)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        button.setCornerRadius(.Relative(percent: 0.3, attribute: .Height), forState: .Normal)
        
		button.setTitle("Present!", forState: .Normal)
		button.titleLabel?.font = UIFont.systemFontOfSize(22)
		
		button.constrainToSize(CGSize(width: 160, height: 50))
		button.constrainToCenterInSuperview()
		
		button.addTarget(self, action: #selector(DropPresentingDemoViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
    }
	
	func buttonTapped(sender: AnyObject) {
		let dummyViewController = UIViewController()
		dummyViewController.view.backgroundColor = UIColor(red:255/255.0, green:186/255.0, blue:1/255.0, alpha:255/255.0)
		dummyViewController.view.layer.cornerRadius = 8.0
        
        let button = Button()
        dummyViewController.view.addSubview(button)
        
        button.setBackgroundImageWithColor(UIColor(red:0.31, green:0.76, blue:0.63, alpha:1.00), forState: .Normal)
        button.setBackgroundImageWithColor(UIColor(red:0.31, green:0.76, blue:0.63, alpha:1.00).colorWithAlphaComponent(0.8), forState: .Highlighted)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        button.setTitle("Dismiss", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(22)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        
        button.addTarget(self, action: #selector(DropPresentingDemoViewController.dismiss(_:)), forControlEvents: .TouchUpInside)
		
        button.constrainToSize(CGSize(width: 120, height: 50))
        button.constrainToCenterInSuperview()
        
		dummyViewController.modalPresentationStyle = .Custom
		dummyViewController.transitioningDelegate = animator
		
		presentViewController(dummyViewController, animated: true, completion: nil)
	}
    
    func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
