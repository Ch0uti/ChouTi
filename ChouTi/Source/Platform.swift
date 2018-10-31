//
//  UIImage+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2017-03-31.
//  Copyright © 2017 Honghaoz. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias Color = UIColor
public typealias Font = UIFont
public typealias Image = UIImage

#elseif os(macOS)
import AppKit
public typealias Color = NSColor
public typealias Font = NSFont
public typealias Image = NSImage

#endif
