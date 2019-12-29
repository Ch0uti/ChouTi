// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

public extension Array where Element: Hashable {
  /// Get a new array with no duplicates while still maintaining the original order.
  func removingDuplicates() -> Self {
    var seen: Set<Iterator.Element> = []
    return filter {
      if seen.contains($0) {
        return false
      }
      seen.insert($0)
      return true
    }
  }

  /// Remove duplicated elements.
  mutating func removeDuplicates() {
    self = removingDuplicates()
  }
}
