// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    func removeAllArrangedSubview() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
