//
//  Calendar+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import Foundation

public extension Calendar {
    /// return Gregorian calendar.
	static var gregorian: Calendar {
        return self.init(identifier: Calendar.Identifier.gregorian)
    }
}
