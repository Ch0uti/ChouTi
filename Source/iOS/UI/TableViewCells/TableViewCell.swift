//
//  TableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-19.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell {
	public var height: CGFloat = 44.0 {
		didSet {
			heightConstraint?.constant = height
		}
	}
	
	private var heightConstraint: NSLayoutConstraint?
	
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: height)
		heightConstraint!.priority = 999
		heightConstraint!.active = true
	}
}

extension TableViewCell : TableViewCellInfo {
	public static func identifier() -> String {
		return NSStringFromClass(TableViewCell.self)
	}
	
	public static func estimatedRowHeight() -> CGFloat {
		return 44.0
	}
	
	public static func registerInTableView(tableView: UITableView) {
		tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier())
	}
}
