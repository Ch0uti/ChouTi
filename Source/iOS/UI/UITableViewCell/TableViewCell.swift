//
//  TableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-19.
//  Copyright © 2015 DogSync. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell {
}

extension TableViewCell : TableViewCellInfo {
	public static func identifier() -> String {
		return NSStringFromClass(TableViewCell.self)
	}
	
	public static func estimatedRowHeight() -> CGFloat {
		return 60
	}
	
	public static func registerInTableView(tableView: UITableView) {
		tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier())
	}
}
