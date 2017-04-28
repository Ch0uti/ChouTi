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

	let leadingMenuView = MenuView(scrollingOption: .leading)
	let centerMenuView = MenuView(scrollingOption: .center)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		automaticallyAdjustsScrollViewInsets = false
		
		leadingMenuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(leadingMenuView)
		
		leadingMenuView.backgroundColor = UIColor.random()
		leadingMenuView.spacingsBetweenMenus = 10.0
		
		centerMenuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(centerMenuView)
		
		centerMenuView.backgroundColor = UIColor.random()
		
		centerMenuView.spacingsBetweenMenus = 10.0
		
        leadingMenuView.bottomAnchor.constraint(equalTo: centerMenuView.topAnchor, constant: -20.0).isActive = true
        leadingMenuView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        leadingMenuView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        leadingMenuView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        centerMenuView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerMenuView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        centerMenuView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        centerMenuView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		leadingMenuView.dataSource = self
		leadingMenuView.delegate = self
		
		centerMenuView.dataSource = self
		centerMenuView.delegate = self
		
		leadingMenuView.selectedIndex = 2
	}
}

extension MenuViewDemoController : MenuViewDataSource {
	func numberOfMenusInMenuView(_ menuView: MenuView) -> Int {
		return 10
	}
	
	func menuView(_ menuView: MenuView, menuViewForIndex index: Int, contentView: UIView?) -> UIView {
		let label = UILabel()
		label.text = "Title \(index)"
		
		if let contentView = contentView {
			label.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(label)
        
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		}
		
		return label
	}
}

extension MenuViewDemoController : MenuViewDelegate {
	func menuView(_ menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat {
		return 50
	}
	
	func menuView(_ menuView: MenuView, didSelectIndex selectedIndex: Int) {
		print("did selected: \(selectedIndex)")
	}
	
	func menuView(_ menuView: MenuView, didScrollToOffset offset: CGFloat) {
		print("did scroll to: \(offset)")
	}
}
