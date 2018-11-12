//
//  Constants.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-10.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public var screenWidth: CGFloat { return UIScreen.main.bounds.size.width }
public var screenHeight: CGFloat { return UIScreen.main.bounds.size.height }

public var screenSize: CGSize { return UIScreen.main.bounds.size }
public var screenBounds: CGRect { return UIScreen.main.bounds }

public var isIpad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }

public var is3_5InchScreen: Bool { return screenHeight ~= 480.0 }
public var is4InchScreen: Bool { return screenHeight ~= 568.0 }

// Ref: http://stackoverflow.com/a/30284266/3164091
public enum Device { static var isSimulator: Bool { return TARGET_OS_SIMULATOR != 0 } }
