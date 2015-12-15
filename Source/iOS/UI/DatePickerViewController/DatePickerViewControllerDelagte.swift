//
//  DatePickerViewControllerDelagte.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

@objc public protocol DatePickerViewControllerDelagte : class {
	optional func datePickerViewController(datePickerViewController: DatePickerViewController, datePicker: UIDatePicker, didScrollToDate date: NSDate)
	optional func datePickerViewController(datePickerViewController: DatePickerViewController, willDoneWithDate date: NSDate)
	optional func datePickerViewController(datePickerViewController: DatePickerViewController, didDoneWithDate date: NSDate)
	
	optional func datePickerViewController(datePickerViewController: DatePickerViewController, willCancelWithDate date: NSDate)
	optional func datePickerViewController(datePickerViewController: DatePickerViewController, didCancelWithDate date: NSDate)
}
