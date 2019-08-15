// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

public extension DispatchQueue {
  private static var _onceTracker = Set<String>()

  /// Executes a block of code, associated with a unique token, only once.
  /// The code is thread safe and will only execute the code once even in the presence of multithreaded calls.
  ///
  /// - Parameters:
  ///   - token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID.
  ///   - block: The block to execute once.
  class func once(token: String, block: () -> Void) {
    objc_sync_enter(self)
    defer {
      objc_sync_exit(self)
    }

    if _onceTracker.contains(token) {
      return
    }

    _onceTracker.insert(token)
    block()
  }
}
