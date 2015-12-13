//
//  DatePickerViewControllerDelagte.swift
//  Pods
//
//  Created by Honghao_Zhang on 2015-12-12.
//
//

import UIKit

public protocol DatePickerViewControllerDelagte : class {
	func datePickerViewController(datePickerViewController: DatePickerViewController, datePicker: UIDatePicker, didScrollToDate date: NSDate)
	func datePickerViewController(datePickerViewController: DatePickerViewController, doneWithDate date: NSDate)
	func datePickerViewController(datePickerViewController: DatePickerViewController, didCancelWithDate date: NSDate)
}
