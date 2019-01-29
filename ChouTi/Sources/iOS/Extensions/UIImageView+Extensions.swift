// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

// MARK: - Animating Images

public extension UIImageView {
    /// Animation FPS, set animationImages first.
    var animationFPS: CGFloat {
        set {
            guard let totalFrames = animationImages?.count else {
                return
            }
            animationDuration = TimeInterval(CGFloat(totalFrames) / newValue)
        }

        get {
            guard let totalFrames = animationImages?.count else {
                return 0.0
            }
            return CGFloat(totalFrames) / CGFloat(animationDuration)
        }
    }
}
