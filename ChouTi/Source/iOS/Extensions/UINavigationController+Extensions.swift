//
//  Created by Honghao Zhang on 2/5/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
