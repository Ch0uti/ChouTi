//
//  TableViewRow.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

public struct TableViewRow : TableViewRowType {
	public var title: String?
	public var subtitle: String?
	public var cellInitialization: ((IndexPath, UITableView) -> UITableViewCell)?
	public var cellConfiguration: ((IndexPath, UITableViewCell, UITableView) -> Void)?
    public var willDisplayCell: ((IndexPath, UITableViewCell, UITableView) -> Void)?
	public var cellSelectAction: ((IndexPath, UITableViewCell?, UITableView) -> Void)?
	public var cellDeselectAction: ((IndexPath, UITableViewCell?, UITableView) -> Void)?
    
	public init() {
		setupDefaultCellConfiguration()
	}
	
	public init(title: String? = nil,
	            subtitle: String? = nil,
	            cellInitialization: ((IndexPath, UITableView) -> UITableViewCell)? = nil,
	            cellConfiguration: ((IndexPath, UITableViewCell, UITableView) -> Void)? = nil,
	            willDisplayCell: ((IndexPath, UITableViewCell, UITableView) -> Void)? = nil,
	            cellSelectAction: ((IndexPath, UITableViewCell?, UITableView) -> Void)? = nil,
	            cellDeselectAction: ((IndexPath, UITableViewCell?, UITableView) -> Void)? = nil) {
		self.title = title
		self.subtitle = subtitle
		
		self.cellInitialization = cellInitialization
		
		if let cellConfiguration = cellConfiguration {
			self.cellConfiguration = cellConfiguration
		} else {
			setupDefaultCellConfiguration()
		}
		
        self.willDisplayCell = willDisplayCell
		self.cellSelectAction = cellSelectAction
		self.cellDeselectAction = cellDeselectAction
	}
	
	fileprivate mutating func setupDefaultCellConfiguration() {
		let title = self.title
		let subtitle = self.subtitle
		self.cellConfiguration = { indexPath, cell, tableView in
			cell.textLabel?.text = title
			cell.detailTextLabel?.text = subtitle
			cell.detailTextLabel?.textColor = UIColor(white: 0.25, alpha: 1.0)
		}
	}
}
