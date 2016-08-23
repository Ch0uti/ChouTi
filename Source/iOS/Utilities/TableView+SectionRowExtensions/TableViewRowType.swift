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
	var cellInitialization: (NSIndexPath -> UITableViewCell)? { get set }
	var cellConfiguration: ((NSIndexPath, UITableViewCell) -> Void)? { get set }
	var cellSelectAction: ((NSIndexPath, UITableViewCell?) -> Void)? { get set }
	var cellDeselectAction: ((NSIndexPath, UITableViewCell?) -> Void)? { get set }
}
