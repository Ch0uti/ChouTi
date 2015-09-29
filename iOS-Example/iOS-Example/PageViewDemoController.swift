//
//  PageViewDemoController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-09-29.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class PageViewDemoController: UIViewController {

	let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
	
	let vc1 = UIViewController()
	let vc2 = UIViewController()
	let vc3 = UIViewController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		vc1.view.backgroundColor = UIColor.redColor()
		vc2.view.backgroundColor = UIColor.greenColor()
		vc3.view.backgroundColor = UIColor.yellowColor()
		
		pageController.setViewControllers([vc2], direction: .Forward, animated: true) { (_) -> Void in
			print("done")
		}
		
		pageController.doubleSided = true
		pageController.dataSource = self
		
		pageController.view.subviews.forEach({ subview in
			if let scrollView = subview as? UIScrollView {
				print("found")
				scrollView.delegate = self
			}
		})
		
		addChildViewController(pageController)
		view.addSubview(pageController.view)
		pageController.didMoveToParentViewController(self)
    }
}

extension PageViewDemoController: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		print(scrollView.contentOffset)
	}
}

extension PageViewDemoController: UIPageViewControllerDataSource {
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		switch viewController {
		case vc1:
			return nil
		case vc2:
			return vc1
		case vc3:
			return vc2
		default:
			return nil
		}
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		switch viewController {
		case vc1:
			return vc2
		case vc2:
			return vc3
		case vc3:
			return nil
		default:
			return nil
		}
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 3
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 1
	}
}
