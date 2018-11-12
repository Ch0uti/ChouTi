//
//  UIScreen+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-25.
//  Copyright © 2018 ChouTi. All rights reserved.
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
