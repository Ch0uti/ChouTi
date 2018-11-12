//
//  Created by Honghao Zhang on 11/18/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

// MARK: - Table View Setup
//tableView.translatesAutoresizingMaskIntoConstraints = false
//<#view#>.addSubview(tableView)
//tableView.separatorStyle = .None
//tableView.allowsSelection = false
//
//tableView.dataSource = self
//tableView.delegate = self
//tableView.rowHeight = UITableViewAutomaticDimension
//
//tableView.canCancelContentTouches = true
//tableView.delaysContentTouches = true

//<#TableViewCell#>.registerInTableView(tableView)

// MARK: - Optional
//// Remove extra separator lines in table view
//// Ref: http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
//tableView.tableFooterView = UIView()

//// MARK: - UITableViewDataSource
//extension <#Class#> : UITableViewDataSource {
//	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//		return <#numberOfSections#>
//	}
//	
//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return <#numberOfRows#>
//	}
//	
//	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCellWithIdentifier(<#TableViewCell#>.identifier()) as! <#TableViewCell#>
//		return cell
//	}
//}

//// MARK: - UITableViewDelegate
//extension <#Class#> : UITableViewDelegate {
//	// MARK: - Rows
//	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return <#TableViewCell#>.estimatedHeight()
//	}
//	
//	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return UITableViewAutomaticDimension
//	}
//	
//	// MARK: - Selections
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
//	}
//
//	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
//	}
//
//	// MARK: - Section Headers
//	func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//		return <#estimatedHeightForHeaderInSection#>
//	}
//	
//	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let view = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
//		view.backgroundColor = UIColor(white: 0.0, alpha: 0.08)
//		view.layoutMargins = UIEdgeInsets(top: 22, left: 8, bottom: 22, right: 8)
//		
//		return view
//	}
//}

// MARK: - Reload a section
// tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
