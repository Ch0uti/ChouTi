//
//  UIStackView+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-23.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    func removeAllArrangedSubview() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
