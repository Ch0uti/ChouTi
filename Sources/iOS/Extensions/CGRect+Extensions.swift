// Copyright © 2019 ChouTi. All rights reserved.

import CoreGraphics

public extension CGRect {
    /// `x`
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }

    /// `y`
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }

    /// `y`
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }

    /// `y + height`
    var bottom: CGFloat {
        get { return y + height }
        set {
            origin.y = newValue - height
        }
    }

    /// `x`
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }

    /// `x + width`
    var right: CGFloat {
        get { return x + width }
        set {
            origin.x = newValue - width
        }
    }

  var upperLeft: CGPoint {
    return CGPoint(x: minX, y: minY)
  }

  var upperRight: CGPoint {
    return CGPoint(x: maxX, y: minY)
  }

  var bottomLeft: CGPoint {
    return CGPoint(x: minX, y: maxY)
  }

  var bottomRight: CGPoint {
    return CGPoint(x: maxX, y: maxY)
  }

  var center: CGPoint {
    get { return CGPoint(x: midX, y: midY) }
    set { origin = CGPoint(x: newValue.x - size.width / 2,
                           y: newValue.y - size.height / 2) }
  }
}
