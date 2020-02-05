// Copyright © 2020 ChouTi. All rights reserved.

import CoreGraphics

public extension CGPoint {
  func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: x + dx, y: y + dy)
  }
}
