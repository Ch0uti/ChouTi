//
//  TableViewCellInfo.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

public protocol TableViewCellInfo {
    static func identifier() -> String
    static func estimatedRowHeight() -> CGFloat
    static func registerInTableView(tableView: UITableView)
}
