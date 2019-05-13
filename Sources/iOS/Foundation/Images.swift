// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

extension UIImage {
    enum ImageAssets: String {
        case Camera
    }

    convenience init!(asset: ImageAssets) {
        self.init(named: asset.rawValue, in: Resource.bundle, compatibleWith: nil)
    }
}
