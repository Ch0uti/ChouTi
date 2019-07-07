// Copyright © 2019 ChouTi. All rights reserved.

import CoreGraphics

public extension CGPoint {
    func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }
}
