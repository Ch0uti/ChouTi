//
//  UIButton+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-12.
//
//

import UIKit

public extension UIButton {
    
    /**
     Sets the background color to use for the specified state.
     
     - parameter color: The background color to use for the specified state.
     - parameter state: The state that uses the specified background color. The possible values are described in UIControlState.
     */
    public func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        self.setBackgroundImage(UIImage.imageWithColor(color), forState: state)
    }
}
