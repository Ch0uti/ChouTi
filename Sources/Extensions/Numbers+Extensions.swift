// Copyright © 2019 ChouTi. All rights reserved.

import CoreGraphics
import Foundation

public extension Comparable {
  /// Return a new copy of clamped `value` to the given limiting range.
  ///
  /// - Parameter limits: range to clamp
  /// - Returns: a new value between in the range.
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(limits.lowerBound, self), limits.upperBound)
  }

  /// Clamping `self` to the given limiting range.
  ///
  /// - Parameter limits: range to clamp
  mutating func clamping(to limits: ClosedRange<Self>) {
    self = clamped(to: limits)
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
  /// Get radians from degrees
  var radian: CGFloat {
    return CGFloat.pi / 180 * self
  }

  /// Get degrees from radians
  var degree: CGFloat {
    return 180 / CGFloat.pi * self
  }
}
