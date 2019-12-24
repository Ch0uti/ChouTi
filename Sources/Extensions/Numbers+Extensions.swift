// Copyright © 2019 ChouTi. All rights reserved.

import CoreGraphics
import Foundation

public extension Comparable {
  /// Clamp `value` to the range min...max.
  ///
  /// - Parameter limits: range to clamp
  /// - Returns: a value between min ... max
  func clamp(to limits: ClosedRange<Self>) -> Self {
    return Swift.min(Swift.max(limits.lowerBound, self), limits.upperBound)
  }

  /// Clamp `self` to the range.
  ///
  /// - Parameter limits: range to clamp
  mutating func clampInPlace(to limits: ClosedRange<Self>) {
    self = Swift.min(Swift.max(limits.lowerBound, self), limits.upperBound)
  }
}

public extension Int {
  /// Get ordinal number abbreviation
  var ordinalNumberAbbreviation: String {
    var suffix: String = ""
    let ones: Int = self % 10
    let tens: Int = (self / 10) % 10

    if tens == 1 {
      suffix = "th"
    } else if ones == 1 {
      suffix = "st"
    } else if ones == 2 {
      suffix = "nd"
    } else if ones == 3 {
      suffix = "rd"
    } else {
      suffix = "th"
    }

    return "\(self)\(suffix)"
  }

  /// Return weekday string (0 - Sunday, 1 - Monday, ...)
  var weekdayString: String? {
    switch self {
    case 0:
      return "Sunday"
    case 1:
      return "Monday"
    case 2:
      return "Tuesday"
    case 3:
      return "Wednesday"
    case 4:
      return "Thursday"
    case 5:
      return "Friday"
    case 6:
      return "Saturday"
    default:
      return nil
    }
  }
}

public extension CGFloat {
  /**
   Get radians from degrees

   - returns: radians
   */
  var radian: CGFloat {
    return CGFloat.pi / 180 * self
  }

  /**
   Get degrees from radians

   - returns: degrees
   */
  func degree() -> CGFloat {
    return 180 / CGFloat.pi * self
  }
}
