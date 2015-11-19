//
//  Constants.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-10.
//
//

import Foundation

public var isIOS7: Bool = !isIOS8
public let isIOS8: Bool = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1

public var screenWidth: CGFloat { return UIScreen.mainScreen().bounds.size.width }
public var screenHeight: CGFloat { return UIScreen.mainScreen().bounds.size.height }

public var screenSize: CGSize { return UIScreen.mainScreen().bounds.size }
public var screenBounds: CGRect { return UIScreen.mainScreen().bounds }

public var isIpad: Bool { return UIDevice.currentDevice().userInterfaceIdiom == .Pad }

public var is3_5InchScreen: Bool { return screenHeight ~= 480.0 }
public var is4InchScreen: Bool { return screenHeight ~= 568.0 }
public var isIphone6: Bool { return screenHeight ~= 667.0 }
public var isIphone6Plus: Bool { return screenHeight ~= 736.0 }
public var is320ScreenWidth: Bool { return screenWidth ~= 320.0 }

var keyWindow: UIWindow { return UIApplication.sharedApplication().keyWindow! }
