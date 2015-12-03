//
//  DropDownMenuDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-12-03.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class DropDownMenuDemoViewController: UIViewController {

	let menu = DropDownMenu()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if let navigationBar = navigationController?.navigationBar {
			menu.translatesAutoresizingMaskIntoConstraints = false
			menu.backgroundColor = UIColor(red:26/255.0, green:25/255.0, blue:38/255.0, alpha:255/255.0)
			menu.textLabel.text = "ESL ESEA EU Season 2"
			menu.textLabel.textColor = UIColor(red:81/255.0, green:45/255.0, blue:168/255.0, alpha:255/255.0)
			
			menu.setHidden(true)
			
			navigationBar.clipsToBounds = false
			navigationBar.addSubview(menu)
			
			var constraints = [NSLayoutConstraint]()
			
			constraints += [NSLayoutConstraint(item: menu, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: menu, attribute: .Leading, relatedBy: .Equal, toItem: navigationBar, attribute: .Leading, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: menu, attribute: .Trailing, relatedBy: .Equal, toItem: navigationBar, attribute: .Trailing, multiplier: 1.0, constant: 0.0)]
			
			constraints += [NSLayoutConstraint(item: menu, attribute: .Height, relatedBy: .Equal, toItem: navigationBar, attribute: .Height, multiplier: 1.2, constant: 0.0)]
			
			NSLayoutConstraint.activateConstraints(constraints)
			
			menu.setHidden(false, animated: true)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		menu.setHidden(true, animated: true)
	}
}
