//
//  Created by Honghao Zhang on 12/14/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension Calendar {
    /// Return Gregorian calendar.
	static var gregorian: Calendar {
        return self.init(identifier: Calendar.Identifier.gregorian)
    }
}
