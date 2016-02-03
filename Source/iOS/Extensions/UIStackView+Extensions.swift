//
//  UIStackView+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-23.
//
//

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    public func removeAllArrangedSubview() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
