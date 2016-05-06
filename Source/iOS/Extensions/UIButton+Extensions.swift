//
//  UIButton+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-12.
//
//

import UIKit

public extension UIButton {
    public func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        self.setBackgroundImage(UIImage.imageWithColor(color), forState: state)
    }
}
