//
//  Calendar+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-14.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension Calendar {
    /// Return Gregorian calendar.
	static var gregorian: Calendar {
        return self.init(identifier: Calendar.Identifier.gregorian)
    }
}
