//
//  CGContext+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-03.
//

public extension CGContext {
    func flipCoordinatesVertically() {
        self.translateBy(x: 0.0, y: CGFloat(self.height))
        self.scaleBy(x: 1.0, y: -1.0)
    }
}
