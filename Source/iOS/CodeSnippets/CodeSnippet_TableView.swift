//
//  CodeSnippet_TableView.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-18.
//
//



// MARK: - Table View Setup
//tableView.separatorStyle = .None
//tableView.allowsSelection = false
//
//tableView.dataSource = self
//tableView.delegate = self
//tableView.rowHeight = UITableViewAutomaticDimension
//
//tableView.canCancelContentTouches = true
//tableView.delaysContentTouches = true



// MARK: - UITableViewDataSource
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
//		let cell = tableView.dequeueReusableCellWithIdentifier(<#identifier#>) as! <#TableViewCell#>
//		return cell
//	}
//}



// MARK: - UITableViewDataSource
//extension <#Class#> : UITableViewDelegate {
//	// MARK: - Rows
//	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return UITableViewAutomaticDimension
//	}
//	
//	// MARK: - Selections
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		tableView.deselectRowAtIndexPath(indexPath, animated: true)
//	}
//	
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
