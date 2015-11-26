//
//  UIScreen+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-25.
//
//

import UIKit

public extension UIScreen {

    public func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    public func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
}