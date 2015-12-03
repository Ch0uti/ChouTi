//
//  SideViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class SideViewController: UIViewController {

	@IBOutlet weak var label: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tableView = UITableView(frame: CGRect(x: 50, y: 50, width: UIScreen.mainScreen().bounds.width - 100, height: 240))
		self.view.addSubview(tableView)
		tableView.userInteractionEnabled = true
		
		tableView.sections = [TableViewSection(headerTitle: "Test",
			rows: [
				TableViewRow(title: "Test",
					cellConfiguration: { cell in
						cell.detailTextLabel?.text = "Test"
					},
					tableView: tableView
				),
				TableViewRow(title: "Test",
					cellConfiguration: { cell in
						cell.detailTextLabel?.text = "Test2"
					},
					tableView: tableView
				),
				TableViewRow(title: "Test",
					cellConfiguration: { cell in
						cell.detailTextLabel?.text = "Test3"
					},
					tableView: tableView
				)
			],
			tableView: tableView)
		]
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
