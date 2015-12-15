//
//  DatePickerViewControllerDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-12-12.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class DatePickerViewControllerDemoViewController : UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		button.setBackgroundColor(UIColor.purpleColor(), forUIControlState: .Normal)
		button.setBackgroundColor(UIColor.purpleColor().colorWithAlphaComponent(0.8), forUIControlState: .Highlighted)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
		
		button.setTitle("Selecte Date", forState: .Normal)
		button.titleLabel?.font = UIFont.systemFontOfSize(22)
		
		button.clipsToBounds = true
		button.layer.cornerRadius = 25
		
		button.constraintToSize(CGSize(width: 160, height: 50))
		button.centerInSuperview()
		
		button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
	}
	
	func buttonTapped(sender: AnyObject) {
		let pickerViewController = DatePickerViewController()
		pickerViewController.datePicker.setDate(NSDate().dateByAddingDays(2), animated: true)
		pickerViewController.delegate = self
		presentViewController(pickerViewController, animated: true, completion: nil)
	}
}

extension DatePickerViewControllerDemoViewController : DatePickerViewControllerDelagte {
	func datePickerViewController(datePickerViewController: DatePickerViewController, datePicker: UIDatePicker, didScrollToDate date: NSDate) {
		print("didScrollToDate: \(date)")
	}
	
	func datePickerViewController(datePickerViewController: DatePickerViewController, didDoneWithDate date: NSDate) {
		print("doneWithDate: \(date)")
	}
	
	func datePickerViewController(datePickerViewController: DatePickerViewController, didCancelWithDate date: NSDate) {
		print("didCancelWithDate: \(date)")
	}
}
