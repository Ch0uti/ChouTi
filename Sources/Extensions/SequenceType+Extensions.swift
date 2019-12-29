// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

public extension Sequence {
  /**
   Return a random subset

   - returns: a random subset
   */
  func randomSubset() -> [Iterator.Element] {
    filter { _ in Bool.random() }
  }

  /**
   If all element match predicate

   - parameter predicate: predicate criterion

   - returns: true if all match.
   */
  func allMatch(_ predicate: (Iterator.Element) -> Bool) -> Bool {
    // Every element matches a predicate if no element doesn't match it
    return !contains { !predicate($0) }
  }
}
