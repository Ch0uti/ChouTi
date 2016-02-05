//
//  DatePickerController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

public class DatePickerController : UIViewController {
	
	public let topToolBar = UIToolbar()
	public let datePicker = UIDatePicker()
	private let slideUpAnimator = SlideUpAnimator()
	
	public var overlayViewStyle: OverlayViewStyle = .Normal(UIColor(white: 0.0, alpha: 0.75))
	
	public weak var delegate: DatePickerControllerDelagte?
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		slideUpAnimator.presentingViewHeight = 264.0 // 44.0 + 220.0
		slideUpAnimator.overlayViewStyle = overlayViewStyle
		
		modalPresentationStyle = .Custom
		transitioningDelegate = slideUpAnimator
		
		topToolBar.barTintColor = UIColor.blackColor()
		topToolBar.tintColor = UIColor.whiteColor()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
		setupConstraints()
	}
	
	private func setupViews() {
		topToolBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(topToolBar)
		
		let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
		let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
		topToolBar.items = [cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem]
		
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(datePicker)
		
		datePicker.addTarget(self, action: "dateUpdated:", forControlEvents: .ValueChanged)
	}
	
	private func setupConstraints() {
		let views = [
			"topToolBar" : topToolBar,
			"datePicker" : datePicker
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[topToolBar]-[datePicker(220)]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: [], metrics: nil, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension DatePickerController {
	func dateUpdated(sender: AnyObject?) {
		guard let datePicker = sender as? UIDatePicker else {
			NSLog("Error: datePicket is nil")
			return
		}
		delegate?.datePickerController?(self, datePicker: datePicker, didScrollToDate: datePicker.date)
	}
	
	func done(sender: AnyObject?) {
		delegate?.datePickerController?(self, willDoneWithDate: datePicker.date)
		dismissViewControllerAnimated(true, completion: { [unowned self] in
			self.delegate?.datePickerController?(self, didDoneWithDate: self.datePicker.date)
		})
	}
	
	func cancel(sender: AnyObject?) {
		delegate?.datePickerController?(self, willCancelWithDate: datePicker.date)
		dismissViewControllerAnimated(true, completion: { [unowned self] in
			self.delegate?.datePickerController?(self, didCancelWithDate: self.datePicker.date)
		})
	}
}

extension DatePickerController : UIToolbarDelegate {
	public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return .Top
	}
}
