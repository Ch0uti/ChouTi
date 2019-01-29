// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UIView {
    func animateIf(_ condition: Bool, duration: TimeInterval, animations: @escaping () -> Void) {
        if condition {
            UIView.animate(withDuration: duration, animations: animations)
        } else {
            animations()
        }
    }

    func animateIf(_ condition: Bool, duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        if condition {
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        } else {
            animations()
            completion?(false)
        }
    }

    // swiftlint:disable:next function_parameter_count
    func animateIf(_ condition: Bool, duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        if condition {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
        } else {
            animations()
            completion?(false)
        }
    }

    // swiftlint:disable:next function_parameter_count
    func animateIf(_ condition: Bool, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIView.AnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        if condition {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
        } else {
            animations()
            completion?(false)
        }
    }
}
