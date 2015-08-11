//
//  UIViewController+Storyboard.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public extension UIViewController {
	
	/**
	Initialize a view controller in storyboard.
	
	:param: storyboardName     Storyboard name
	:param: viewControllerName Storyboard ID of the view controller
	
	:returns: An instance of view controller.
	*/
	class func viewControllerInStoryboard(storyboardName: String , viewControllerName: String) -> UIViewController {
		var storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
		var viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UIViewController
		return viewController
	}
}
