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

	let navigationBarMenu = DropDownMenu()
	let smallMenu = DropDownMenu()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if let navigationBar = navigationController?.navigationBar {
			navigationBarMenu.setHidden(true)
			
			navigationBarMenu.translatesAutoresizingMaskIntoConstraints = false
			navigationBarMenu.dataSource = self
			navigationBarMenu.delegate = self
			
			navigationBarMenu.selectedIndex = 2
			
			view.addSubview(navigationBarMenu)
			
			var constraints = [NSLayoutConstraint]()
			
			// navigationBarMenu
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0)]
			
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .Height, relatedBy: .Equal, toItem: navigationBar, attribute: .Height, multiplier: 1.0, constant: 0.0)]
			
			// smallMenu
			smallMenu.translatesAutoresizingMaskIntoConstraints = false
			smallMenu.dataSource = self
			smallMenu.delegate = self
			smallMenu.selectedIndex = 0
			smallMenu.backgroundColor = UIColor.purpleColor()
			view.addSubview(smallMenu)
			
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 100.0)]
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 100.0)]
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -100.0)]
			
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 60.0)]
			
			NSLayoutConstraint.activateConstraints(constraints)
			
			navigationBarMenu.setHidden(false, animated: true)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationBarMenu.setHidden(true, animated: true, duration: 1.0, completion: { finished in
			self.navigationBarMenu.removeFromSuperview()
		})
	}
}

extension DropDownMenuDemoViewController : DropDownMenuDataSource {
	func numberOfOptionsInDropDownMenu(dropDownMenu: DropDownMenu) -> Int {
		return 4
	}
	
	func dropDownMenu(dropDownMenu: DropDownMenu, optionTitleForIndex index: Int) -> String {
		return "Option \(index)"
	}
}

extension DropDownMenuDemoViewController : DropDownMenuDelegate {
	func dropDownMenu(dropDownMenu: DropDownMenu, didSelectedIndex index: Int) {
		print("dropDownMenu didSelectedIndex: \(index)")
	}
}
