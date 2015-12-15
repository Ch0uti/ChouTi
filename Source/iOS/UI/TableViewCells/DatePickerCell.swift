//
//  DatePickerCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-06.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public class DatePickerCell : TableViewCell {

	public let datePicker = UIDatePicker()
	
	override func commonInit() {
		super.commonInit()
		
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

extension DatePickerCell {
	public override class func estimatedRowHeight() -> CGFloat {
		return 200.0
	}
}
