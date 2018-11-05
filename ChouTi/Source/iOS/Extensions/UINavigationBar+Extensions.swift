//
//  UINavigationBar+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-17.
//

import UIKit

public extension UINavigationBar {
    public func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = true
    }

    public func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = false
    }

    private func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
        if let view = view as? UIImageView, view.bounds.height <= 1.0 {
            return view
        }

        for subview in view.subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }

        return nil
    }
}

// MARK: - Customization of navigation bar title
public extension UINavigationBar {
    var titleTextColor: UIColor? {
        set {
            if let titleTextColor = newValue {
                if titleTextAttributes != nil {
                    titleTextAttributes?[.foregroundColor] = titleTextColor
                } else {
                    titleTextAttributes = [.foregroundColor: titleTextColor]
                }
            } else {
				// FIXME: revist it when Xcode 8.2
                _ = titleTextAttributes?.removeValue(forKey: .foregroundColor)
            }
        }

        get {
            if let titleTextAttributes = titleTextAttributes {
                return titleTextAttributes[.foregroundColor] as? UIColor
            } else {
                return nil
            }
        }
    }

    var titleTextFont: UIFont? {
        set {
            if let titleTextFont = newValue {
                if titleTextAttributes != nil {
                    titleTextAttributes?[.font] = titleTextFont
                } else {
                    titleTextAttributes = [.font: titleTextFont]
                }
            } else {
                _ = titleTextAttributes?.removeValue(forKey: .font)
            }
        }

        get {
            if let titleTextAttributes = titleTextAttributes {
                return titleTextAttributes[.font] as? UIFont
            } else {
                return nil
            }
        }
    }
}

// MARK: - Transparent
public extension UINavigationBar {
    func setToTransparent(_ transparent: Bool) {
        if transparent {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
        } else {
            setBackgroundImage(nil, for: .default)
            shadowImage = nil
        }
    }
}
