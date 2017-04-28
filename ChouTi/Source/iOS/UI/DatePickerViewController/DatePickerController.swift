//
//  DatePickerController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-12.
//
//

import UIKit

open class DatePickerController : UIViewController {
	
	open let topToolBar = UIToolbar()
	open let datePicker = UIDatePicker()
	fileprivate let slideUpAnimator = SlideUpAnimator()
	
	open var overlayViewStyle: OverlayViewStyle = .normal(UIColor(white: 0.0, alpha: 0.75))
	
	open weak var delegate: DatePickerControllerDelagte?
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	fileprivate func commonInit() {
		slideUpAnimator.presentedViewHeight = 264.0 // 44.0 + 220.0
		slideUpAnimator.overlayViewStyle = overlayViewStyle
		
		modalPresentationStyle = .custom
		transitioningDelegate = slideUpAnimator
		
		topToolBar.barTintColor = UIColor.black
		topToolBar.tintColor = UIColor.white
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		setupViews()
		setupConstraints()
	}
	
	fileprivate func setupViews() {
		topToolBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(topToolBar)
		
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DatePickerController.cancel(_:)))
		let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DatePickerController.done(_:)))
		topToolBar.items = [cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem]
		
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(datePicker)
		
		datePicker.addTarget(self, action: #selector(DatePickerController.dateUpdated(_:)), for: .valueChanged)
	}
	
	fileprivate func setupConstraints() {
		let views = [
			"topToolBar" : topToolBar,
			"datePicker" : datePicker
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topToolBar]-[datePicker(220)]", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[datePicker]|", options: [], metrics: nil, views: views)
		
		NSLayoutConstraint.activate(constraints)
	}
}

extension DatePickerController {
	func dateUpdated(_ sender: AnyObject?) {
		guard let datePicker = sender as? UIDatePicker else {
			NSLog("Error: datePicket is nil")
			return
		}
		delegate?.datePickerController?(self, datePicker: datePicker, didScrollToDate: datePicker.date)
	}
	
	func done(_ sender: AnyObject?) {
		delegate?.datePickerController?(self, willDoneWithDate: datePicker.date)
		dismiss(animated: true, completion: { [unowned self] in
			self.delegate?.datePickerController?(self, didDoneWithDate: self.datePicker.date)
		})
	}
	
	func cancel(_ sender: AnyObject?) {
		delegate?.datePickerController?(self, willCancelWithDate: datePicker.date)
		dismiss(animated: true, completion: { [unowned self] in
			self.delegate?.datePickerController?(self, didCancelWithDate: self.datePicker.date)
		})
	}
}

extension DatePickerController : UIToolbarDelegate {
	public func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .top
	}
}
