//
//  TableViewSectionType.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-15.
//
//

import Foundation

public protocol TableViewSectionType {
	weak var tableView: UITableView? { get set }
	var headerTitle: String? { get set }
	var footerTitle: String? { get set }
	var shouldShowIndex: Bool { get set }
	var rows: [TableViewRowType] { get set }
}

extension TableViewSectionType {
	weak var tableView: UITableView? { return nil }
	var headerTitle: String? { return nil }
	var footerTitle: String? { return nil }
	var shouldShowIndex: Bool { return false }
	var rows: [TableViewRowType] { return [] }
}
