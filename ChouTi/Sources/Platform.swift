// Copyright © 2019 ChouTi. All rights reserved.

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
