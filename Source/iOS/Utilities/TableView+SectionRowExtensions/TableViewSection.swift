//
//  TableViewSection.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-15.
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
