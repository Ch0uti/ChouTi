//
//  SideViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {

	@IBOutlet weak var label: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tableView = UITableView(frame: CGRect(x: 50, y: 50, width: UIScreen.mainScreen().bounds.width - 100, height: 240))
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
		tableView.dataSource = self
		tableView.delegate = self
		self.view.addSubview(tableView)
		tableView.userInteractionEnabled = true
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		print("\(label.text!)ViewController: viewWillAppear")
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		print("\(label.text!)ViewController: viewDidAppear")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		print("\(label.text!)ViewController: viewWillDisappear")
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		print("\(label.text!)ViewController: viewDidDisappear")
	}
	
//	override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
//		super.beginAppearanceTransition(isAppearing, animated: animated)
//		print("\(label.text!)ViewController: beginAppearanceTransition")
//	}
//	
//	override func endAppearanceTransition() {
//		super.endAppearanceTransition()
//		print("\(label.text!)ViewController: endAppearanceTransition")
//	}
}

extension SideViewController : UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("id")
		cell?.textLabel?.text = "test"
		
		return cell!
	}
}

extension SideViewController : UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("selected: \(indexPath.row)")
	}
}
