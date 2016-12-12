//
//  DatePickerControllerDelagte.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

@objc public protocol DatePickerControllerDelagte : class {
	@objc optional func datePickerController(_ datePickerController: DatePickerController, datePicker: UIDatePicker, didScrollToDate date: Date)
	@objc optional func datePickerController(_ datePickerController: DatePickerController, willDoneWithDate date: Date)
	@objc optional func datePickerController(_ datePickerController: DatePickerController, didDoneWithDate date: Date)
	
	@objc optional func datePickerController(_ datePickerController: DatePickerController, willCancelWithDate date: Date)
	@objc optional func datePickerController(_ datePickerController: DatePickerController, didCancelWithDate date: Date)
}
