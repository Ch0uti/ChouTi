//
//  MenuViewDemoController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-10-15.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MenuViewDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		automaticallyAdjustsScrollViewInsets = false
		
		let menuView = MenuView()
		menuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(menuView)
		
		menuView.backgroundColor = UIColor.random()
		menuView.spacingsBetweenMenus = 10.0
		
		if #available(iOS 9.0, *) {
			menuView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
			menuView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
			
			menuView.widthAnchor.constraintEqualToConstant(250).active = true
			menuView.heightAnchor.constraintEqualToConstant(100).active = true
		} else {
			// Fallback on earlier versions
		}
		
		menuView.dataSource = self
		menuView.delegate = self
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
