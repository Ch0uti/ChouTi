//
//  MenuPageDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-10-15.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MenuPageDemoViewController : UIViewController {

    let viewControllers: [UIViewController] = {
        return [0, 1, 2, 3, 4, 5].map { DummyViewController(label: "vc\($0)") }
    }()
	
	let menuPageViewController = MenuPageViewController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		view.backgroundColor = UIColor.whiteColor()
		
		menuPageViewController.menuView.spacingsBetweenMenus = 60
		
		menuPageViewController.dataSource = self
		menuPageViewController.delegate = self
		
		menuPageViewController.selectedIndex = 4
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		addChildViewController(menuPageViewController)
		let frame = menuPageViewController.view.frame
		menuPageViewController.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 22 + 44, width: frame.width, height: frame.height - 20 - 44)
		view.addSubview(menuPageViewController.view)
		menuPageViewController.didMoveToParentViewController(self)
    }
}

extension MenuPageDemoViewController : MenuPageViewControllerDataSource {
	func numberOfMenusInMenuPageViewController(menuPageViewController: MenuPageViewController) -> Int {
		return viewControllers.count
	}
	
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuViewForIndex index: Int, contentView: UIView?) -> UIView {
		let labelBackgroundView = UIView()
		labelBackgroundView.backgroundColor = UIColor.random()
	
		let label = UILabel()
		label.text = "Title \(index)"
		label.translatesAutoresizingMaskIntoConstraints = false
		
		labelBackgroundView.addSubview(label)
		
		if let contentView = contentView {
			labelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(labelBackgroundView)
			
            labelBackgroundView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
            labelBackgroundView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
            labelBackgroundView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
            labelBackgroundView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
            
            label.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
            label.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
		}
		
		return label
	}
	
	func menuPageViewController(menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController {
		return viewControllers[index]
	}
}

extension MenuPageDemoViewController : MenuPageViewControllerDelegate {
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuWidthForIndex index: Int) -> CGFloat {
		return 50
	}
	
	func menuPageViewController(menuPageViewController: MenuPageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController) {
		//
	}
}
