//
//  DatePickerControllerDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-12-12.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class DatePickerControllerDemoViewController : UIViewController {
	
	let resultLabel = UILabel()
	
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
		
		button.addTarget(self, action: #selector(DatePickerControllerDemoViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
		
		resultLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(resultLabel)
		resultLabel.font = UIFont.AvenirMediumFont(21)
		resultLabel.textColor = UIColor.blackColor()
		resultLabel.text = "Select a date."
		
		if #available(iOS 9.0, *) {
		    resultLabel.topAnchor.constraintEqualToAnchor(button.bottomAnchor, constant: 40).active = true
			resultLabel.centerXAnchor.constraintEqualToAnchor(button.centerXAnchor).active = true
		} else {
		    // Fallback on earlier versions
		}
	}
	
	func buttonTapped(sender: AnyObject) {
		let pickerController = DatePickerController()
		pickerController.datePicker.setDate(NSDate(), animated: true)
		pickerController.datePicker.datePickerMode = .DateAndTime
		pickerController.datePicker.minimumDate = NSDate().dateByAddingDays(-30)
		pickerController.datePicker.maximumDate = NSDate().dateByAddingDays(30)
		pickerController.delegate = self
		presentViewController(pickerController, animated: true, completion: nil)
	}
}

extension DatePickerControllerDemoViewController : DatePickerControllerDelagte {
	func datePickerController(datePickerController: DatePickerController, datePicker: UIDatePicker, didScrollToDate date: NSDate) {
		print("didScrollToDate: \(date)")
	}
	
	func datePickerController(datePickerController: DatePickerController, willDoneWithDate date: NSDate) {
		print("doneWithDate: \(date)")
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "hh:mm a, EEE, MMM d, yyyy"
		resultLabel.text = dateFormatter.stringFromDate(date)
	}
	
	func datePickerController(datePickerController: DatePickerController, didCancelWithDate date: NSDate) {
		print("didCancelWithDate: \(date)")
	}
}
