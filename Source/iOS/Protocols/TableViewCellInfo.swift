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
	Sample: return String(self)
	
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
	Sample: tableView.registerClass(self, forCellReuseIdentifier: identifier())
	
	- parameter tableView: target table view to use this cell
	*/
    static func registerInTableView(tableView: UITableView)
}



// Sample Implementation:

// MARK: - TableViewCellInfo
//extension <#TableViewCell#> : TableViewCellInfo {
//	public class func identifier() -> String {
//		return String(self)
//	}
//	
//	public class func estimatedRowHeight() -> CGFloat {
//		return 44.0
//	}
//	
//	public class func registerInTableView(tableView: UITableView) {
//		tableView.registerClass(self, forCellReuseIdentifier: identifier())
//	}
//}
