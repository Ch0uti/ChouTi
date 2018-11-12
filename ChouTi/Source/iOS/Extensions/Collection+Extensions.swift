//
//  Created by Honghao Zhang on 10/16/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension Collection {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.
     
     - parameter safe: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    subscript (safe index: Index) -> Iterator.Element? {
        return at(index)
    }

    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.
     
     - parameter index: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    func at(_ index: Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
