//
//  Created by Honghao Zhang on 11/12/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UIButton {

    /**
     Sets the background image color to use for the specified state.
     
     - parameter color: The background image color to use for the specified state.
     - parameter state: The state that uses the specified background image color. The possible values are described in UIControlState.
     */
    @objc
    func setBackgroundImageWithColor(_ color: UIColor, forState state: UIControl.State) {
        self.setBackgroundImage(UIImage.imageWithColor(color), for: state)
    }
}
