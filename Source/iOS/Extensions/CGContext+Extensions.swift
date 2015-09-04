//
//  CGContext+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-03.
//
//

import UIKit

public extension CGContext {
	public func flipCoordinatesVertically() {
		CGContextTranslateCTM(self, 0.0, CGFloat(CGBitmapContextGetHeight(self)))
		CGContextScaleCTM(self, 1.0, -1.0)
	}
}
