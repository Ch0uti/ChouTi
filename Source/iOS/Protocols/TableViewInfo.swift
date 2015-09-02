//
//  TableViewInfo.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-11.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public protocol TableViewInfo {
    static func identifier() -> String
    static func estimatedRowHeight() -> CGFloat
    static func registerInTableView(tableView: UITableView)
}
