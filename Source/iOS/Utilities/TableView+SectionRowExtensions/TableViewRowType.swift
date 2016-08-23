//
//  TableViewRowType.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

public protocol TableViewRowType {
	var title: String? { get set }
	var subtitle: String? { get set }
    
    /// Initialize a cell
	var cellInitialization: ((NSIndexPath, UITableView) -> UITableViewCell)? { get set }
    /// Configure a cell after cell is initialized
	var cellConfiguration: ((NSIndexPath, UITableViewCell, UITableView) -> Void)? { get set }
	var cellSelectAction: ((NSIndexPath, UITableViewCell?, UITableView) -> Void)? { get set }
	var cellDeselectAction: ((NSIndexPath, UITableViewCell?, UITableView) -> Void)? { get set }
    
    var willDisplayCell: ((NSIndexPath, UITableViewCell, UITableView) -> Void)? { get set }
}
