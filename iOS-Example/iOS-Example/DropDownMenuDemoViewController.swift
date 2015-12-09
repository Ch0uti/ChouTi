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
	let zhMenu = ZHDropDownMenu()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if let navigationBar = navigationController?.navigationBar {
			menu.translatesAutoresizingMaskIntoConstraints = false
			menu.backgroundColor = UIColor(white: 0.8, alpha: 1.0) //UIColor(red:26/255.0, green:25/255.0, blue:38/255.0, alpha:255/255.0)
			menu.textLabel.text = "Option 1"
			menu.textLabel.textColor = UIColor(red:81/255.0, green:45/255.0, blue:168/255.0, alpha:255/255.0)
			
			menu.setHidden(true)
			
			zhMenu.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(zhMenu)
			
			view.addSubview(menu)
			
			var constraints = [NSLayoutConstraint]()
			
			constraints += [NSLayoutConstraint(item: menu, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: menu, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: menu, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0)]
			
			constraints += [NSLayoutConstraint(item: menu, attribute: .Height, relatedBy: .Equal, toItem: navigationBar, attribute: .Height, multiplier: 1.2, constant: 0.0)]
			
			zhMenu.centerInSuperview()
			zhMenu.dataSource = self
			
			NSLayoutConstraint.activateConstraints(constraints)
			
			menu.setHidden(false, animated: true)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		menu.setHidden(true, animated: true, duration: 1.0, completion: { finished in
			self.menu.removeFromSuperview()
		})
	}
}

extension DropDownMenuDemoViewController : ZHDropDownMenuDataSource {
	func numberOfItemsInDropDownMenu(menu: ZHDropDownMenu) -> Int {
		return 10
	}
	func zhDropDownMenu(menu: ZHDropDownMenu, itemTitleForIndex index: Int) -> String {
		return "sss123-abc"
	}
}
