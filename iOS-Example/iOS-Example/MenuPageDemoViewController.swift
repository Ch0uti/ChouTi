//
//  MenuPageDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-10-15.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MenuPageDemoViewController : UIViewController {

	var dummyViewControllers: [UIViewController]!
	
	let menuPageViewController = MenuPageViewController()
	
    override func viewDidLoad() {
		view.backgroundColor = UIColor.whiteColor()
		
		menuPageViewController.menuView.spacingsBetweenMenus = 60
		
		let vc1 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc1.view.backgroundColor = UIColor.random()
		vc1.label.text = "vc1"
		vc1.view.frame = UIScreen.mainScreen().bounds
		
		let vc2 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc2.view.backgroundColor = UIColor.random()
		vc2.label.text = "vc2"
		vc2.view.frame = UIScreen.mainScreen().bounds
		
		let vc3 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc3.view.backgroundColor = UIColor.random()
		vc3.label.text = "vc3"
		vc3.view.frame = UIScreen.mainScreen().bounds
		
		let vc4 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc4.view.backgroundColor = UIColor.random()
		vc4.label.text = "vc4"
		vc4.view.userInteractionEnabled = false
		
		let vc5 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc5.view.backgroundColor = UIColor.random()
		vc5.label.text = "vc5"
		
		let vc6 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc6.view.backgroundColor = UIColor.random()
		vc6.label.text = "vc6"
		
		dummyViewControllers = [vc1, vc2, vc3, vc4, vc5, vc6]
		
		menuPageViewController.dataSource = self
		menuPageViewController.delegate = self
		
		menuPageViewController.selectedIndex = 4
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		addChildViewController(menuPageViewController)
		let frame = menuPageViewController.view.frame
		menuPageViewController.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 22 + 44, width: frame.width, height: frame.height - 20 - 44)
		view.addSubview(menuPageViewController.view)
		menuPageViewController.didMoveToParentViewController(self)
		
		super.viewDidLoad()
    }
}

extension MenuPageDemoViewController : MenuPageViewControllerDataSource {
	func numberOfMenusInMenuPageViewController(menuPageViewController: MenuPageViewController) -> Int {
		return dummyViewControllers.count
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
			
			if #available(iOS 9.0, *) {
				labelBackgroundView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
				labelBackgroundView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
				labelBackgroundView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
				labelBackgroundView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
				
				label.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
				label.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
			} else {
				// Fallback on earlier versions
			}
		}
		
		return label
	}
	
	func menuPageViewController(menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController {
		return dummyViewControllers[index]
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
