//
//  OnceTask.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-15.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation

public class Once {
    public class func task(task: dispatch_block_t) {
        struct Tokens { static var token: dispatch_once_t = 0 }
        dispatch_once(&Tokens.token) {
            task()
        }
    }
}
