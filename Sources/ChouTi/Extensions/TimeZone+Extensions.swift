// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

public extension TimeZone {
  /// Get GMT time zone. If fails, fall back to `autoupdatingCurrent`.
  static var gmt: TimeZone {
    guard let gmt = TimeZone(abbreviation: "GMT") else {
      debugPrint("Error: time zone with `GMT` abbreviation not found")
      return TimeZone.autoupdatingCurrent
    }
    return gmt
  }

  /// Get EST time zone. If fails, fall back to `autoupdatingCurrent`.
  static var est: TimeZone {
    guard let est = TimeZone(abbreviation: "EST") else {
      debugPrint("Error: time zone with `EST` abbreviation not found")
      return TimeZone.autoupdatingCurrent
    }
    return est
  }

  /// Get CST time zone. If fails, fall back to `autoupdatingCurrent`.
  static var cst: TimeZone {
    guard let cst = TimeZone(abbreviation: "CST") else {
      debugPrint("Error: time zone with `CST` abbreviation not found")
      return TimeZone.autoupdatingCurrent
    }
    return cst
  }

  /// Get MST time zone. If fails, fall back to `autoupdatingCurrent`.
  static var mst: TimeZone {
    guard let mst = TimeZone(abbreviation: "MST") else {
      debugPrint("Error: time zone with `MST` abbreviation not found")
      return TimeZone.autoupdatingCurrent
    }
    return mst
  }

  /// Get PST time zone. If fails, fall back to `autoupdatingCurrent`.
  static var pst: TimeZone {
    guard let pst = TimeZone(abbreviation: "PST") else {
      debugPrint("Error: time zone with `PST` abbreviation not found")
      return TimeZone.autoupdatingCurrent
    }
    return pst
  }
}
