//
//  MenuViewDemoController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-10-15.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MenuViewDemoController: UIViewController {

	let leadingMenuView = MenuView(scrollingOption: .Leading)
	let centerMenuView = MenuView(scrollingOption: .Center)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		automaticallyAdjustsScrollViewInsets = false
		
		leadingMenuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(leadingMenuView)
		
		leadingMenuView.backgroundColor = UIColor.random()
		leadingMenuView.spacingsBetweenMenus = 10.0
		
		centerMenuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(centerMenuView)
		
		centerMenuView.backgroundColor = UIColor.random()
		
		centerMenuView.spacingsBetweenMenus = 10.0
		
		if #available(iOS 9.0, *) {
			leadingMenuView.bottomAnchor.constraintEqualToAnchor(centerMenuView.topAnchor, constant: -20.0).active = true
			leadingMenuView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
			
			leadingMenuView.widthAnchor.constraintEqualToConstant(300).active = true
			leadingMenuView.heightAnchor.constraintEqualToConstant(100).active = true
			
			centerMenuView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
			centerMenuView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
			
			centerMenuView.widthAnchor.constraintEqualToConstant(300).active = true
			centerMenuView.heightAnchor.constraintEqualToConstant(100).active = true
		} else {
			// Fallback on earlier versions
		}
		
		leadingMenuView.dataSource = self
		leadingMenuView.delegate = self
		
		centerMenuView.dataSource = self
		centerMenuView.delegate = self
		
		leadingMenuView.selectedIndex = 2
	}
}

extension MenuViewDemoController : MenuViewDataSource {
	func numberOfMenusInMenuView(menuView: MenuView) -> Int {
		return 10
	}
	
	func menuView(menuView: MenuView, menuViewForIndex index: Int, contentView: UIView?) -> UIView {
		let label = UILabel()
		label.text = "Title \(index)"
		
		if let contentView = contentView {
			label.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(label)
			
			if #available(iOS 9.0, *) {
				label.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
				label.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
			} else {
				// Fallback on earlier versions
			}
		}
		
		return label
	}
}

extension MenuViewDemoController : MenuViewDelegate {
	func menuView(menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat {
		return 50
	}
	
	func menuView(menuView: MenuView, didSelectIndex selectedIndex: Int) {
		print("did selected: \(selectedIndex)")
	}
	
	func menuView(menuView: MenuView, didScrollToOffset offset: CGFloat) {
		print("did scroll to: \(offset)")
	}
}
