// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

public extension Calendar {
    /// Returns Gregorian calendar.
    static var gregorian: Calendar {
        return self.init(identifier: Calendar.Identifier.gregorian)
    }
}
