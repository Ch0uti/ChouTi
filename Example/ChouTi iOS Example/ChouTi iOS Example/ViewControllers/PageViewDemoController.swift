//
//  PageViewDemoController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-09-29.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class PageViewDemoController: UIViewController {
	
	let pageViewController = PageViewController()
	var dummyViewControllers: [UIViewController]!
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		
        pageViewController.delegate = self
        
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
		
		dummyViewControllers = [vc1, vc2, vc3, vc4]
		
        // 1: Set view controllers directly
//        pageViewController.viewControllers = dummyViewControllers
		
        // 2: Set view controllers by data source
        pageViewController.dataSource = self

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
	}
}

extension PageViewDemoController : PageViewControllerDataSource {
	func numberOfViewControllersInPageViewController(pageViewController: PageViewController) -> Int {
		return dummyViewControllers.count
	}
	
	func pageViewController(pageViewController: PageViewController, viewControllerForIndex index: Int) -> UIViewController {
		print("asking for index: \(index)")
		return dummyViewControllers[index]
	}
}

extension PageViewDemoController : PageViewControllerDelegate {
	func pageViewController(pageViewController: PageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController) {
		print("did selected: \(selectedIndex)")
	}
	
	func pageViewController(pageViewController: PageViewController, didScrollWithSelectedIndex selectedIndex: Int, offsetPercent: CGFloat) {
//		print("scroll offset: \(offsetPercent)")
	}
}
