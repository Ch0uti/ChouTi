// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

public extension Collection {
  /// Returns an optional element. Returns nil if the `index` is out of bounds.
  subscript(safe index: Index) -> Iterator.Element? {
    return (startIndex ..< endIndex).contains(index) ? self[index] : nil
  }
}
