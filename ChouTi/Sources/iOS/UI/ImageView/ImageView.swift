// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

open class ImageView: UIImageView {
    open var rounded: Bool = false

    open override func layoutSubviews() {
        super.layoutSubviews()

        if rounded {
            layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        }
    }
}
