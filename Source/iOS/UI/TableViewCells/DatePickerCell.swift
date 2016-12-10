//
//  DatePickerCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-06.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

open class DatePickerCell : TableViewCell {

	open let datePicker = UIDatePicker()
	
	override open func commonInit() {
		super.commonInit()
		
		setupViews()
		setupConstraints()
	}
	
	fileprivate func setupViews() {
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(datePicker)
	}
	
	fileprivate func setupConstraints() {
		let views = [
			"datePicker" : datePicker
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[datePicker]-|", options: [], metrics: nil, views: views)
		
		constraints += [NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
		
		constraints += [NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 200.0)]
		
		NSLayoutConstraint.activate(constraints)
	}
}

extension DatePickerCell {
	open override class func estimatedHeight() -> CGFloat {
		return 200.0
	}
}
