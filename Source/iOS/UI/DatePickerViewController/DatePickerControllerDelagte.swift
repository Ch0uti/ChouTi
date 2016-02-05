//
//  DatePickerControllerDelagte.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

@objc public protocol DatePickerControllerDelagte : class {
	optional func datePickerController(datePickerController: DatePickerController, datePicker: UIDatePicker, didScrollToDate date: NSDate)
	optional func datePickerController(datePickerController: DatePickerController, willDoneWithDate date: NSDate)
	optional func datePickerController(datePickerController: DatePickerController, didDoneWithDate date: NSDate)
	
	optional func datePickerController(datePickerController: DatePickerController, willCancelWithDate date: NSDate)
	optional func datePickerController(datePickerController: DatePickerController, didCancelWithDate date: NSDate)
}
