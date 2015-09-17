//
//  UIViewController+Storyboard.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-10.
//

import UIKit

public extension UIViewController {
    
    /**
    Initialize a view controller in storyboard.
    
    :param: storyboardName     Storyboard name
    :param: viewControllerName Storyboard ID of the view controller
    
    :returns: An instance of view controller.
    */
    class public func viewControllerInStoryboard(storyboardName: String , viewControllerName: String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName)
        return viewController
    }
}
