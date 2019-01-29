// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
