//
//  DatePickerCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-06.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class DatePickerCell : UITableViewCell {

	let datePicker = UIDatePicker()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		setupViews()
		setupConstraints()
	}
	
	private func setupViews() {
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(datePicker)
	}
	
	private func setupConstraints() {
		let views = [
			"datePicker" : datePicker
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[datePicker]-|", options: [], metrics: nil, views: views)
		
		constraints += [NSLayoutConstraint(item: datePicker, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
		
		constraints += [NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 200.0)]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension DatePickerCell : TableViewCellInfo {
	static func identifier() -> String {
		return NSStringFromClass(DatePickerCell.self)
	}
	
	static func estimatedRowHeight() -> CGFloat {
		return 200.0
	}
	
	static func registerInTableView(tableView: UITableView) {
		tableView.registerClass(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.identifier())
	}
}
