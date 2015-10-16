//
//  PageViewDemoController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-09-29.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class PageViewDemoController: PageViewController {
	
	var dummyViewControllers: [UIViewController]!
	
    override func viewDidLoad() {
		self.view.backgroundColor = UIColor.whiteColor()
		
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
		
		// demoMenuPageViewController.viewControllers = dummyViewControllers
		
		self.dataSource = self
		self.delegate = self
		
		// demoMenuPageViewController.scrollEnabled = false
		super.viewDidLoad()
		
		self.setSelectedIndex(2, animated: true)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		delay(seconds: 0.5, completion: { _ in
			self.setSelectedIndex(1, animated: true)
		})
		
		delay(seconds: 1.0, completion: { _ in
			self.setSelectedIndex(3, animated: true)
		})
		
		delay(seconds: 4.0, completion: { _ in
			self.dummyViewControllers! += self.dummyViewControllers!
			print("self.dumycount: \(self.dummyViewControllers.count)")
		})
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
}
