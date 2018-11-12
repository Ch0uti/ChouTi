//
//  Created by Honghao Zhang on 01/13/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UISearchBar {
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }

    // Ref: http://stackoverflow.com/questions/2834573/how-to-animate-the-change-of-image-in-an-uiimageview
    func setBackgroundColorAroundTextField(_ color: UIColor?, animated: Bool, duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {

        UIView.transition(with: self, duration: animated ? duration : 0.0, options: .transitionCrossDissolve, animations: { () -> Void in
            if let color = color {
                self.backgroundImage = UIImage.imageWithColor(color)
            } else {
                self.backgroundImage = nil
            }
            }, completion: completion)
    }
}
