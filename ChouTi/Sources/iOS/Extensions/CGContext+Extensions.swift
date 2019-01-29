// Copyright © 2019 ChouTi. All rights reserved.

import CoreGraphics

public extension CGContext {
    func flipCoordinatesVertically() {
        translateBy(x: 0.0, y: CGFloat(height))
        scaleBy(x: 1.0, y: -1.0)
    }
}
