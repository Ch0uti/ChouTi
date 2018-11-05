//
//  UIScreen+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-25.
//
//

import UIKit

public extension UIScreen {
    func height() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    func width() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
