//
//  UINavigationController+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-02-05.
//
//

import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
