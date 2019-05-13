// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension NSLayoutXAxisAnchor {
    @discardableResult
    func constrain(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(equalTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
    }
}

public extension NSLayoutYAxisAnchor {
    @discardableResult
    func constrain(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(equalTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
    }
}

public extension NSLayoutDimension {
    @discardableResult
    func constrain(to anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(equalTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(greaterThanOrEqualTo anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualTo: anchor, constant: constant).activate()
    }

    @discardableResult
    func constrain(lessThanOrEqualTo anchor: NSLayoutDimension, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualTo: anchor, constant: constant).activate()
    }
}

public extension NSLayoutDimension {
    @discardableResult
    func constrain(to constant: CGFloat) -> NSLayoutConstraint {
        return constraint(equalToConstant: constant).activate()
    }

    @discardableResult
    func constrain(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func constrain(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func constrain(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(equalTo: anchor, multiplier: multiplier, constant: constant).activate()
    }

    @discardableResult
    func constrain(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }

    @discardableResult
    func constrain(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).activate()
    }
}
