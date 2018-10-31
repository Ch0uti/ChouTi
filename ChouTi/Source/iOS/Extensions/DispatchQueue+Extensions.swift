//
//  DispatchQueue+Extensions.swift
//  ChouTi iOS
//
//  Created by Honghao Zhang on 10/18/18.
//  Copyright © 2018 Honghaoz. All rights reserved.
//

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
