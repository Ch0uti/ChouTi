//
//  TableViewSectionRowType.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
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

public typealias CellSelectionActionBlock = ((indexPath: NSIndexPath, cell: UITableViewCell?) -> Void)

public protocol TableViewRowType {
	weak var tableView: UITableView? { get set }
	var title: String? { get set }
	var subtitle: String? { get set }
	var cellInitialization: (NSIndexPath -> UITableViewCell)? { get set }
	var cellConfiguration: (UITableViewCell -> Void)? { get set }
	var cellSelectAction: CellSelectionActionBlock? { get set }
	var cellDeselectAction: CellSelectionActionBlock? { get set }
}
