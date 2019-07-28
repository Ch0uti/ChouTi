// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}

extension UINavigationController {
    /// Make navigation controller respect the top view controller's status bar style.
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
