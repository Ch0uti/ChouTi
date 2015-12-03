//
//  TableViewSectionRow.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

public struct TableViewSection: TableViewSectionType {
	public weak var tableView: UITableView?
	public var headerTitle: String?
	public var footerTitle: String?
	public var shouldShowIndex: Bool = false
	public var rows: [TableViewRowType] = []
	
	public init() {}
	public init(headerTitle: String? = nil, rows: [TableViewRowType], tableView: UITableView) {
		self.tableView = tableView
		self.headerTitle = headerTitle
		self.rows = rows
	}
}

public struct TableViewRow: TableViewRowType {
	public weak var tableView: UITableView?
	public var title: String?
	public var subtitle: String?
	public var cellConfiguration: (UITableViewCell -> Void)?
	public var cellSelectAction: CellSelectionActionBlock?
	public var cellDeselectAction: CellSelectionActionBlock?
	
	public init() {
		setupDefaultCellConfiguration()
	}
	
	public init(title: String?, subtitle: String? = nil, cellConfiguration: (UITableViewCell -> Void)? = nil, tableView: UITableView, cellSelectAction: CellSelectionActionBlock? = nil, cellDeselectAction: CellSelectionActionBlock? = nil) {
		self.tableView = tableView
		self.title = title
		self.subtitle = subtitle
		
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
