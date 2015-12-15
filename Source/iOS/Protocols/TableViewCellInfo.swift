//
//  TableViewCellInfo.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

// Use `class` instead of `static` to let subclass override class method
// Reference: http://stackoverflow.com/questions/29636633/static-vs-class-functions-variables-in-swift-classes

public protocol TableViewCellInfo {
	/**
	Default cell reuse identifier for cell
	Sample: return NSStringFromClass(<#Cell#>.self)
	
	- returns: a cell reuse identifier
	*/
    static func identifier() -> String
	
	/**
	Default estimated row height
	Sample: return <#RowHeight#>
	
	- returns: estimated row height
	*/
	
    static func estimatedRowHeight() -> CGFloat
	
	/**
	Register in table view helper methods
	Sample: tableView.registerClass(<#Cell#>.self, forCellReuseIdentifier: <#Cell#>.identifier())
	
	- parameter tableView: target table view to use this cell
	*/
    static func registerInTableView(tableView: UITableView)
}
