//
//  DatePickerControllerDemoViewController.swift
//  ChouTi iOS Example
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
		
		view.backgroundColor = UIColor.white
		
		let button = Button()
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		button.setBackgroundImageWithColor(UIColor.purple, forState: .normal)
		button.setBackgroundImageWithColor(UIColor.purple.darkerColor(), forState: .highlighted)
		button.setTitleColor(UIColor.white, for: .normal)
		button.setTitleColor(UIColor.white.darkerColor(), for: .highlighted)
		button.setCornerRadius(.halfCircle, forState: .normal)
        
		button.setTitle("Select Date", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
		
        button.constrainTo(size: CGSize(width: 160, height: 50))
		button.constrainToCenterInSuperview()
		
        button.addTarget(controlEvents: .touchUpInside) { [unowned self] button in
            let pickerController = DatePickerController()
            pickerController.datePicker.setDate(Date(), animated: true)
            pickerController.datePicker.datePickerMode = .dateAndTime
            pickerController.datePicker.minimumDate = Date().date(bySetting: .day, with: -30)
            pickerController.datePicker.maximumDate = Date().date(bySetting: .day, with: 30)
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        }
		
		resultLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(resultLabel)
		resultLabel.font = UIFont.AvenirMediumFont(21)
		resultLabel.textColor = UIColor.black
		resultLabel.text = "Selected Date"

        resultLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 40).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
	}
}

extension DatePickerControllerDemoViewController : DatePickerControllerDelagte {
	func datePickerController(_ datePickerController: DatePickerController, datePicker: UIDatePicker, didScrollToDate date: Date) {
		print("didScrollToDate: \(date)")
	}
	
	func datePickerController(_ datePickerController: DatePickerController, willDoneWithDate date: Date) {
		print("doneWithDate: \(date)")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm a, EEE, MMM d, yyyy"
		resultLabel.text = dateFormatter.string(from: date)
	}
	
	func datePickerController(_ datePickerController: DatePickerController, didCancelWithDate date: Date) {
		print("didCancelWithDate: \(date)")
	}
}
