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
		
		menuPageViewController.dataSource = self
		menuPageViewController.delegate = self
		
		let vc1 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc1.view.backgroundColor = UIColor.blueColor()
		vc1.label.text = "vc1"
		vc1.view.frame = UIScreen.mainScreen().bounds
		
		let vc2 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc2.view.backgroundColor = UIColor.redColor()
		vc2.label.text = "vc2"
		vc1.view.frame = UIScreen.mainScreen().bounds
		
		let vc3 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc3.view.backgroundColor = UIColor.greenColor()
		vc3.label.text = "vc3"
		vc3.view.frame = UIScreen.mainScreen().bounds
		
		let vc4 = SideViewController(nibName: "SideViewController", bundle: nil)
		vc4.view.backgroundColor = UIColor.purpleColor()
		vc4.label.text = "vc4"
		
		dummyViewControllers = [vc1, vc2, vc3, vc4]
		
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
