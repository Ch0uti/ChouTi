//
//  UINavigationController+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-02-05.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
