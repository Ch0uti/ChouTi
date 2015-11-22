//
//  TableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-19.
//  Copyright © 2015 DogSync. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
}

extension TableViewCell : TableViewCellInfo {
	static func identifier() -> String {
		return NSStringFromClass(TableViewCell.self)
	}
	
	static func estimatedRowHeight() -> CGFloat {
		return 60
	}
	
	static func registerInTableView(tableView: UITableView) {
		tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier())
	}
}
