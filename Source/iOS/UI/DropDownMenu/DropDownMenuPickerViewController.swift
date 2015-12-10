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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}

	private func setupViews() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		
		tableView.separatorStyle = .None
		tableView.allowsSelection = false
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableViewAutomaticDimension
		
		tableView.canCancelContentTouches = true
		tableView.delaysContentTouches = true
		
		TableViewCell.registerInTableView(tableView)
	}

	private func setupConstraints() {
		let views = [
			"tableView" : tableView
		]

		let metrics: [String : CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: metrics, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}



// MARK: - UITableViewDataSource
extension DropDownMenuPickerViewController : UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier()) as! TableViewCell
		
		cell.textLabel?.text = "LOL"
		cell.cellHeight = 80.0
		
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
		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
	}

	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
	}
}
