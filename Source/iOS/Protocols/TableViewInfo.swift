//
//  TableViewCellInfo.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

public protocol TableViewCellInfo {
    static func identifier() -> String
	// return NSStringFromClass(<#Cell#>.self)
	
    static func estimatedRowHeight() -> CGFloat
	// return <#RowHeight#>
	
    static func registerInTableView(tableView: UITableView)
	// tableView.registerClass(<#Cell#>.self, forCellReuseIdentifier: <#Cell#>.identifier())
}
