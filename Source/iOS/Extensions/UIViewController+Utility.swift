//
//  UIViewController+Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//
//

import UIKit

public extension UIViewController {
    
    /**
    Check whether childViewControllers contain a view controller
    
    :param: childViewController View controller to be tested
    
    :returns: True if contained, false otherwise
    */
    public func containChildViewController(childViewController: UIViewController) -> Bool {
        return self.childViewControllers.filter({$0 == childViewController}).count > 0
    }
}
