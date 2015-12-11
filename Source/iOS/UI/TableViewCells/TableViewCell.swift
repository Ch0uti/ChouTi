//
//  TableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-19.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public class TableViewCell : UITableViewCell {
	public var cellHeight: CGFloat = 44.0 {
		didSet {
			heightConstraint?.constant = cellHeight
		}
	}
	
	private var heightConstraint: NSLayoutConstraint?
	
	public var selectedAccessoryView: UIView? {
		didSet {
			if selectedAccessoryType != .None {
				selectedAccessoryType = .None
			}
		}
	}
	
	public var selectedAccessoryType: UITableViewCellAccessoryType = .None {
		didSet {
			if selectedAccessoryView != nil {
				selectedAccessoryView = nil
			}
		}
	}
	
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		heightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: cellHeight)
		heightConstraint!.priority = 500
		heightConstraint!.active = true
	}
	
	public override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		if selectedAccessoryType != .None {
			accessoryType = selected ? selectedAccessoryType : .None
		}
		
		if selectedAccessoryView != nil {
			accessoryView = selected ? selectedAccessoryView : nil
		}
	}
}

extension TableViewCell : TableViewCellInfo {
	public class func identifier() -> String {
		return NSStringFromClass(TableViewCell.self)
	}
	
	public class func estimatedRowHeight() -> CGFloat {
		return 44.0
	}
	
	public class func registerInTableView(tableView: UITableView) {
		tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier())
	}
}
