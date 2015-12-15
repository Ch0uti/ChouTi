//
//  TableViewRowType.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

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
