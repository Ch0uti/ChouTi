//
//  UIImageView+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-08-07.
//
//

import UIKit

// MARK: - Animating Images
public extension UIImageView {
    /// Animation FPS, set animationImages first.
    var animationFPS: CGFloat {
        set {
            guard let totalFrames = animationImages?.count else {
                return
            }
            self.animationDuration = TimeInterval(CGFloat(totalFrames) / newValue)
        }

        get {
            guard let totalFrames = animationImages?.count else {
                return 0.0
            }
            return CGFloat(totalFrames) / CGFloat(self.animationDuration)
        }
    }
}
