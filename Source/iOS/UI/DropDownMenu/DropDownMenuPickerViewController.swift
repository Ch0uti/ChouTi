//
//  DropDownMenuPickerViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-09.
//
//

import UIKit

class DropDownMenuPickerViewController : UIViewController {
	
	let tableView = UITableView()
	
	weak var dropDownMenu: DropDownMenu?
	
	var animationDuration: NSTimeInterval = 0.5
	
	var optionCellHeight: CGFloat = 44.0 {
		didSet {
			tableViewHeightConstraint?.constant = ceil(optionCellHeight * CGFloat(numberOfOptions))
		}
	}
	
	private var _optionTextColor: UIColor?
	var optionTextColor: UIColor? {
		get {
			return _optionTextColor ?? UIColor.blackColor()
		}
		
		set {
			_optionTextColor = newValue
		}
	}
	
	private var _optionTextFont: UIFont?
	var optionTextFont: UIFont? {
		get {
			return _optionTextFont ?? dropDownMenu?.textLabel.font
		}
		set {
			_optionTextFont = newValue
		}
	}
	
	private var _optionTextAlignment: NSTextAlignment?
	var optionTextAlignment: NSTextAlignment {
		get {
			return _optionTextAlignment ?? dropDownMenu?.textLabel.textAlignment ?? .Left
		}
		set {
			_optionTextAlignment = newValue
		}
	}
	
	private var _optionCellBackgroundColor: UIColor?
	var optionCellBackgroundColor: UIColor? {
		get {
			return _optionCellBackgroundColor ?? UIColor.whiteColor()
		}
		set {
			_optionCellBackgroundColor = newValue
			tableView.backgroundColor = _optionCellBackgroundColor
		}
	}
	
	private var _optionSeparatorColor: UIColor? {
		didSet {
			tableView.separatorColor = _optionSeparatorColor
		}
	}
	var optionSeparatorColor: UIColor? {
		get {
			return _optionSeparatorColor ?? UIColor(white: 0.75, alpha: 1.0)
		}
		set {
			_optionSeparatorColor = newValue
		}
	}
	
	private(set) var isExpanded: Bool = false
	
	private var tableViewHeightConstraint: NSLayoutConstraint!
	private var expandedConstraints = [NSLayoutConstraint]()
	private var collapsedConstraints = [NSLayoutConstraint]()
	
	private var numberOfOptions: Int {
		return tableView(tableView, numberOfRowsInSection: 0)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let dropDownMenu = dropDownMenu {
			optionCellHeight = dropDownMenu.height
		}
		
		setupViews()
		setupConstraints()
	}

	private func setupViews() {
		view.clipsToBounds = true
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		
		tableView.backgroundColor = optionCellBackgroundColor
		
		tableView.separatorStyle = .SingleLine
		tableView.separatorInset = UIEdgeInsetsZero
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableViewAutomaticDimension
		
		tableView.canCancelContentTouches = true
		tableView.delaysContentTouches = true
		
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		
		TableViewCell.registerInTableView(tableView)
	}

	private func setupConstraints() {
		let views = [
			"tableView" : tableView
		]

		let metrics: [String : CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: ceil(optionCellHeight * CGFloat(numberOfOptions)))
		tableViewHeightConstraint.priority = 750
		constraints += [tableViewHeightConstraint]
		
		let maxHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		constraints += [maxHeightConstraint]
		
		collapsedConstraints += [
			NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
		]
		constraints += collapsedConstraints
		
		expandedConstraints += [
			NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
		]
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: metrics, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if let dropDownMenu = dropDownMenu {
			optionCellHeight = dropDownMenu.height
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		view.layoutIfNeeded()
		
		expandOptions()
	}
	
	override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
		collapseOptions({ _ in
			super.dismissViewControllerAnimated(flag, completion: completion)
		})
	}
}



// MARK: - Animations
extension DropDownMenuPickerViewController {
	func expandOptions(completion: ((Bool) -> Void)? = nil) {
		if isExpanded {
			completion?(false)
			return
		}
		
		NSLayoutConstraint.deactivateConstraints(collapsedConstraints)
		NSLayoutConstraint.activateConstraints(expandedConstraints)
		
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: {
			self.view.layoutIfNeeded()
		}, completion: { finished in
			self.isExpanded = true
			completion?(finished)
		})
	}
	
	func collapseOptions(completion: ((Bool) -> Void)? = nil) {
		if !isExpanded {
			completion?(false)
			return
		}
		
		NSLayoutConstraint.deactivateConstraints(expandedConstraints)
		NSLayoutConstraint.activateConstraints(collapsedConstraints)
		
		UIView.animateWithDuration(animationDuration * 2 / 3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: {
			self.view.layoutIfNeeded()
		}, completion: { finished in
			self.isExpanded = false
			completion?(finished)
		})
	}
}



// MARK: - UITableViewDataSource
extension DropDownMenuPickerViewController : UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let dropDownMenu = dropDownMenu else {
			assertionFailure("Error: dropDownMenu is nil")
			return 0
		}
		
		guard let menuDataSource = dropDownMenu.dataSource else {
			assertionFailure("Error: dataSource for DropDownMenu is nil")
			return 0
		}
		
		return menuDataSource.numberOfOptionsInDropDownMenu(dropDownMenu)
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier()) as! TableViewCell
		
		guard let dropDownMenu = dropDownMenu else {
			assertionFailure("Error: dropDownMenu is nil")
			return cell
		}
		
		cell.textLabel?.text = dropDownMenu.dataSource.dropDownMenu(dropDownMenu, optionTitleForIndex: indexPath.row)
		
		cell.cellHeight = optionCellHeight
		cell.textLabel?.textColor = optionTextColor
		cell.textLabel?.font = optionTextFont
		cell.textLabel?.textAlignment = optionTextAlignment
		cell.backgroundColor = UIColor.clearColor()
		
		// Full width separator
		cell.preservesSuperviewLayoutMargins = false
		cell.separatorInset = UIEdgeInsetsZero
		cell.layoutMargins = UIEdgeInsetsZero
		
		return cell
	}
}



// MARK: - UITableViewDataSource
extension DropDownMenuPickerViewController : UITableViewDelegate {
	// MARK: - Rows
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return TableViewCell.estimatedRowHeight()
	}

	// MARK: - Selections
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		guard let dropDownMenu = dropDownMenu else {
			assertionFailure("Error: dropDownMenu is nil")
			return
		}
		
		collapseOptions { _ in
			dropDownMenu.selectedIndex = indexPath.row
			dropDownMenu.delegate?.dropDownMenu(dropDownMenu, didSelectedIndex: indexPath.row)
			dropDownMenu.menuAnimator.dismisscurrentPresentedViewController()
		}
	}
}
