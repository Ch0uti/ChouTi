// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

// MARK: - Overlay View

extension UIView {
    private enum zhOverlayViewKey {
        static var Key = "zhOverlayViewKey"
    }

    private var zhOverlayView: UIView? {
        get { return objc_getAssociatedObject(self, &zhOverlayViewKey.Key) as? UIView }
        set { objc_setAssociatedObject(self, &zhOverlayViewKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func addOverlayView(
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.6),
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ overlayViewBackgroundColor: UIColor) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.addSubview(overlayView)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    public func insertOverlayViewBelowSubview(
        _ belowSubview: UIView,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ overlayViewBackgroundColor: UIColor) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.insertSubview(overlayView, belowSubview: belowSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    public func insertOverlayViewAboveSubview(
        _ aboveSubview: UIView,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ overlayViewBackgroundColor: UIColor) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.insertSubview(overlayView, aboveSubview: aboveSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            overlayViewBackgroundColor: overlayViewBackgroundColor,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    private func _setupOverlayView(
        viewConfiguration: ((UIView) -> Void),
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        overlayViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ overlayViewBackgroundColor: UIColor) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = overlayViewBackgroundColor

        if viewKeyPointer != nil {
            if getAssociatedViewForKeyPointer(viewKeyPointer!) != nil {
                print("Warning: found existing overlay view with viewKeyPointer: \(String(describing: viewKeyPointer))")
            }

            setAssociatedView(overlayView, forKeyPointer: viewKeyPointer!)
        } else {
            if zhOverlayView != nil {
                print("Warning: found existing overlay view")
            }

            // Let self keep the reference to the view, used for retriving the overlay view
            zhOverlayView = overlayView
        }

        if !animated {
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            beginning?(animated, duration, delay, dampingRatio, velocity, overlayViewBackgroundColor)
            completion?(overlayView)
        } else {
            overlayView.alpha = 0.0
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()

            beginning?(animated, duration, delay, dampingRatio, velocity, overlayViewBackgroundColor)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                overlayView.alpha = 1.0
            }, completion: { _ -> Void in
                completion?(overlayView)
            })
        }

        return overlayView
    }

    public func removeOverlayView(
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat) -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        let overlayView: UIView
        if viewKeyPointer != nil {
            guard let theOverlayView = getAssociatedViewForKeyPointer(viewKeyPointer!) else {
                print("Error: overlay view is not existed")
                beginning?(animated, duration, delay, dampingRatio, velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        } else {
            guard let theOverlayView = zhOverlayView else {
                print("Error: overlay view is not existed")
                beginning?(animated, duration, delay, dampingRatio, velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        }

        if !animated {
            overlayView.removeFromSuperview()
            if viewKeyPointer != nil {
                clearAssociatedViewForKeyPointer(viewKeyPointer!)
            } else {
                zhOverlayView = nil
            }

            beginning?(animated, duration, delay, dampingRatio, velocity)
            completion?(true)
        } else {
            beginning?(animated, duration, delay, dampingRatio, velocity)
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: .beginFromCurrentState, animations: {
                overlayView.alpha = 0.0
            }, completion: { [unowned self] finished -> Void in
                overlayView.removeFromSuperview()
                if viewKeyPointer != nil {
                    self.clearAssociatedViewForKeyPointer(viewKeyPointer!)
                } else {
                    self.zhOverlayView = nil
                }
                completion?(finished)
            })
        }
    }

    // MARK: - Blurred Overlay View

    private enum zhBlurredOverlayViewKey {
        static var Key = "zhBlurredOverlayViewKey"
    }

    private var zhBlurredOverlayView: UIView? {
        get { return objc_getAssociatedObject(self, &zhBlurredOverlayViewKey.Key) as? UIView }
        set { objc_setAssociatedObject(self, &zhBlurredOverlayViewKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func addBlurredOverlayView(
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffect.Style = .dark,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ blurredViewBackgroundColor: UIColor, _ blurEffectStyle: UIBlurEffect.Style) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupBlurredOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.addSubview(overlayView)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    public func insertBlurredOverlayViewBelowSubview(
        _ belowSubview: UIView,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffect.Style = .dark,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ blurredViewBackgroundColor: UIColor, _ blurEffectStyle: UIBlurEffect.Style) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupBlurredOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.insertSubview(overlayView, belowSubview: belowSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    public func insertBlurredOverlayViewAboveSubview(
        _ aboveSubview: UIView,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffect.Style = .dark,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ blurredViewBackgroundColor: UIColor, _ blurEffectStyle: UIBlurEffect.Style) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        return _setupBlurredOverlayView(
            viewConfiguration: { [unowned self] overlayView in
                self.insertSubview(overlayView, aboveSubview: aboveSubview)
            },
            animated: animated,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            blurredViewBackgroundColor: blurredViewBackgroundColor,
            blurEffectStyle: blurEffectStyle,
            viewKeyPointer: viewKeyPointer,
            beginning: beginning,
            completion: completion
        )
    }

    private func _setupBlurredOverlayView(
        viewConfiguration: ((UIView) -> Void),
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        blurredViewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        blurEffectStyle: UIBlurEffect.Style = .dark,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat, _ blurredViewBackgroundColor: UIColor, _ blurEffectStyle: UIBlurEffect.Style) -> Void)? = nil,
        completion: ((_ overlayView: UIView) -> Void)? = nil
    ) -> UIView {
        if zhBlurredOverlayView != nil {
            print("warning: found existing blurred overlay view")
        }

        let overlayView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = blurredViewBackgroundColor

        if viewKeyPointer != nil {
            if getAssociatedViewForKeyPointer(viewKeyPointer!) != nil {
                print("Warning: found existing blurred overlay view with viewKeyPointer: \(String(describing: viewKeyPointer))")
            }

            setAssociatedView(overlayView, forKeyPointer: viewKeyPointer!)
        } else {
            if zhBlurredOverlayView != nil {
                print("warning: found existing blurred overlay view")
            }

            // Let self keep the reference to the view, used for retriving the overlay view
            zhBlurredOverlayView = overlayView
        }

        if !animated {
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()
            beginning?(animated, duration, delay, dampingRatio, velocity, blurredViewBackgroundColor, blurEffectStyle)
            completion?(overlayView)
        } else {
            overlayView.alpha = 0.0
            viewConfiguration(overlayView)
            overlayView.constrainToFullSizeInSuperview()

            beginning?(animated, duration, delay, dampingRatio, velocity, blurredViewBackgroundColor, blurEffectStyle)
            completion?(overlayView)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                overlayView.alpha = 1.0
            }, completion: { _ -> Void in
                completion?(overlayView)
            })
        }

        return overlayView
    }

    public func removeBlurredOverlayView(
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        dampingRatio: CGFloat = 1.0,
        velocity: CGFloat = 1.0,
        viewKeyPointer: UnsafePointer<String>? = nil,
        beginning: ((_ animated: Bool, _ duration: TimeInterval, _ delay: TimeInterval, _ dampingRatio: CGFloat, _ velocity: CGFloat) -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        let overlayView: UIView
        if viewKeyPointer != nil {
            guard let theOverlayView = getAssociatedViewForKeyPointer(viewKeyPointer!) else {
                print("Error: blurred overlay view is not existed")
                beginning?(animated, duration, delay, dampingRatio, velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        } else {
            guard let theOverlayView = zhBlurredOverlayView else {
                print("Error: blurred overlay view is not existed")
                beginning?(animated, duration, delay, dampingRatio, velocity)
                completion?(false)
                return
            }
            overlayView = theOverlayView
        }

        if !animated {
            overlayView.removeFromSuperview()
            if viewKeyPointer != nil {
                clearAssociatedViewForKeyPointer(viewKeyPointer!)
            } else {
                zhBlurredOverlayView = nil
            }
            beginning?(animated, duration, delay, dampingRatio, velocity)
            completion?(true)
        } else {
            beginning?(animated, duration, delay, dampingRatio, velocity)
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                overlayView.alpha = 0.0
            }, completion: { [unowned self] finished -> Void in
                overlayView.removeFromSuperview()
                if viewKeyPointer != nil {
                    self.clearAssociatedViewForKeyPointer(viewKeyPointer!)
                } else {
                    self.zhBlurredOverlayView = nil
                }
                completion?(finished)
            })
        }
    }

    // MARK: - Helper Methos

    @discardableResult
    private func setAssociatedView(_ view: UIView, forKeyPointer keyPointer: UnsafePointer<String>) -> UIView? {
        let associatedView = getAssociatedViewForKeyPointer(keyPointer)
        objc_setAssociatedObject(self, keyPointer, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associatedView
    }

    private func getAssociatedViewForKeyPointer(_ keyPointer: UnsafePointer<String>) -> UIView? {
        return objc_getAssociatedObject(self, keyPointer) as? UIView
    }

    @discardableResult
    private func clearAssociatedViewForKeyPointer(_ keyPointer: UnsafePointer<String>) -> UIView? {
        let associatedView = getAssociatedViewForKeyPointer(keyPointer)
        objc_setAssociatedObject(self, keyPointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associatedView
    }
}
