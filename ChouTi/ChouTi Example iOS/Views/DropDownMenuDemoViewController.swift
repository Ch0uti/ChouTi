//
//  DropDownMenuDemoViewController.swift
//  ChouTi iOS Example
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
		
		view.backgroundColor = UIColor.white
    }
	
	override func viewDidAppear(_ animated: Bool) {
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
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)]
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)]
			
			constraints += [NSLayoutConstraint(item: navigationBarMenu, attribute: .height, relatedBy: .equal, toItem: navigationBar, attribute: .height, multiplier: 1.0, constant: 0.0)]
			
			// smallMenu
			smallMenu.translatesAutoresizingMaskIntoConstraints = false
			smallMenu.dataSource = self
			smallMenu.delegate = self
			smallMenu.selectedIndex = 0
			smallMenu.backgroundColor = UIColor.purple
			smallMenu.statusBarStyle = .lightContent
			view.addSubview(smallMenu)
			
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1.0, constant: 100.0)]
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 100.0)]
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -100.0)]
			
			constraints += [NSLayoutConstraint(item: smallMenu, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 60.0)]
			
			NSLayoutConstraint.activate(constraints)
			
			navigationBarMenu.setHidden(false, animated: true)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationBarMenu.setHidden(true, animated: true, duration: 1.0, completion: { finished in
			self.navigationBarMenu.removeFromSuperview()
		})
	}
}

extension DropDownMenuDemoViewController : DropDownMenuDataSource {
	func numberOfOptionsInDropDownMenu(_ dropDownMenu: DropDownMenu) -> Int {
		return 6
	}
	
	func dropDownMenu(_ dropDownMenu: DropDownMenu, optionTitleForIndex index: Int) -> String {
		return "Option \(index)"
	}
}

extension DropDownMenuDemoViewController : DropDownMenuDelegate {
	func dropDownMenu(_ dropDownMenu: DropDownMenu, willSelectIndex index: Int) {
		print("dropDownMenu willSelectIndex: \(index)")
	}
	
	func dropDownMenu(_ dropDownMenu: DropDownMenu, didSelectIndex index: Int) {
		print("dropDownMenu didSelectIndex: \(index)")
	}
	
	func dropDownMenuWillExpand(_ dropDownMenu: DropDownMenu) {
		print("dropDownMenuWillExpand")
	}
	
	func dropDownMenuDidExpand(_ dropDownMenu: DropDownMenu) {
		print("dropDownMenuDidExpand")
	}
	
	func dropDownMenuWillCollapse(_ dropDownMenu: DropDownMenu) {
		print("dropDownMenuWillCollapse")
	}
	
	func dropDownMenuDidCollapse(_ dropDownMenu: DropDownMenu) {
		print("dropDownMenuDidCollapse")
	}
}
