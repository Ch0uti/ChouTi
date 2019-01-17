//
//  Created by Honghao Zhang on 10/16/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension Collection {
    /// Returns an optional element. Returns nil if the `index` is out of bounds.
    subscript (safe index: Index) -> Iterator.Element? {
        return at(index)
    }

    /// Returns an optional element. Returns nil if the `index` is out of bounds.
    func at(_ index: Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
