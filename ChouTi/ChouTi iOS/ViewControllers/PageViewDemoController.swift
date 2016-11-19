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
    let viewControllers: [UIViewController] = {
        return [0, 1, 2, 3].map { DummyViewController(label: "vc\($0)") }
    }()
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
        pageViewController.delegate = self
		
        // 1: Set view controllers directly
//        pageViewController.viewControllers = viewControllers
		
        // 2: Set view controllers by data source
        pageViewController.dataSource = self

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
	}
}

extension PageViewDemoController : PageViewControllerDataSource {
	func numberOfViewControllersInPageViewController(_ pageViewController: PageViewController) -> Int {
		return viewControllers.count
	}
	
	func pageViewController(_ pageViewController: PageViewController, viewControllerForIndex index: Int) -> UIViewController {
		print("asking for index: \(index)")
		return viewControllers[index]
	}
}

extension PageViewDemoController : PageViewControllerDelegate {
	func pageViewController(_ pageViewController: PageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController) {
		print("did selected: \(selectedIndex)")
	}
	
	func pageViewController(_ pageViewController: PageViewController, didScrollWithSelectedIndex selectedIndex: Int, offsetPercent: CGFloat) {
//		print("scroll offset: \(offsetPercent)")
	}
}
