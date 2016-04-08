//
//  TableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-19.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell {
	
	/// Cell height, this is the constant for height constraint (250 priority).
	//	Discussion: You can fully specify cell's height to ignore cell height (Use constraints with priorty greater than 250)
	public var cellHeight: CGFloat = 44.0 {
		didSet {
			heightConstraint?.constant = cellHeight
		}
	}
	
	private var heightConstraint: NSLayoutConstraint?
	
	public var selectedAccessoryView: UIView?
	public var selectedAccessoryType: UITableViewCellAccessoryType = .None
	
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	public func commonInit() {
		heightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: cellHeight)
		heightConstraint?.priority = 250
		heightConstraint?.active = true
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
