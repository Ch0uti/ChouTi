//
//  Types.swift
//  Pods
//
//  Created by Honghao_Zhang on 2015-12-12.
//
//

import Foundation

// Customize overlay view style
/**
Overlay View Style

- Normal:  This is a normal overlay view with a customized background color
- Blurred: This is blurred overlay view with blur effect style and background color
*/
public enum OverlayViewStyle {
	case Normal(UIColor)
	case Blurred(UIBlurEffectStyle, UIColor)
}
