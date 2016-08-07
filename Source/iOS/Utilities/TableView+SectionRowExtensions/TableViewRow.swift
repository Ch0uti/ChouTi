//
//  TableViewRow.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

public struct TableViewRow : TableViewRowType {
	public weak var tableView: UITableView?
	public var title: String?
	public var subtitle: String?
	public var cellInitialization: (NSIndexPath -> UITableViewCell)?
	public var cellConfiguration: (UITableViewCell -> Void)?
	public var cellSelectAction: CellSelectionActionBlock?
	public var cellDeselectAction: CellSelectionActionBlock?
	
	public init() {
		setupDefaultCellConfiguration()
	}
	
	public init(title: String?, subtitle: String? = nil, cellInitialization: (NSIndexPath -> UITableViewCell)? = nil, cellConfiguration: (UITableViewCell -> Void)? = nil, tableView: UITableView? = nil, cellSelectAction: CellSelectionActionBlock? = nil, cellDeselectAction: CellSelectionActionBlock? = nil) {
		self.tableView = tableView
		self.title = title
		self.subtitle = subtitle
		
		self.cellInitialization = cellInitialization
		
		if let cellConfiguration = cellConfiguration {
			self.cellConfiguration = cellConfiguration
		} else {
			setupDefaultCellConfiguration()
		}
		
		self.cellSelectAction = cellSelectAction
		self.cellDeselectAction = cellDeselectAction
	}
	
	private mutating func setupDefaultCellConfiguration() {
		self.cellConfiguration = { cell in
			cell.textLabel?.text = self.title
			cell.detailTextLabel?.text = self.subtitle
			cell.detailTextLabel?.textColor = UIColor(white: 0.25, alpha: 1.0)
		}
	}
}
