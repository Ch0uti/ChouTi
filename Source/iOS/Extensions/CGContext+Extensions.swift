//
//  CGContext+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-03.
//

public extension CGContext {
    public func flipCoordinatesVertically() {
        CGContextTranslateCTM(self, 0.0, CGFloat(CGBitmapContextGetHeight(self)))
        CGContextScaleCTM(self, 1.0, -1.0)
    }
}
