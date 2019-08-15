// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

extension DispatchQueue {
  /// Dispatch the block to main queue asynchronously if needed.
  class func onMainAsync(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      DispatchQueue.main.async {
        block()
      }
    }
  }

  /// Dispatch the block to main queue synchronously if needed.
  class func onMainSync(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      DispatchQueue.main.sync {
        block()
      }
    }
  }
}
