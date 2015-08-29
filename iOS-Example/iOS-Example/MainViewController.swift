//
//  MainViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MainViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var slideViewController: SlideController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}
	
	func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.showBottomHairline()
	}
}

extension MainViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self)) as! UITableViewCell
			
			cell.textLabel?.text = "Navigation Bar Hide Hairline"
			
			return cell
		case 1:
			let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self)) as! UITableViewCell
			
			cell.textLabel?.text = "SlideController"
			
			return cell
		default:
			return UITableViewCell()
		}
	}
}

extension MainViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		switch indexPath.row {
		case 0:
			let dummyViewController = UIViewController()
			dummyViewController.view.backgroundColor = UIColor.whiteColor()
			self.navigationController?.pushViewController(dummyViewController, animated: true)
			
			dummyViewController.navigationController?.navigationBar.hideBottomHairline()
		case 1:
			let centerVC = UIViewController()
			centerVC.view.backgroundColor = UIColor.whiteColor()
			
			let centerNavi = UINavigationController(rootViewController: centerVC)
			centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Done, target: self, action: "expandLeft:")
			centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: UIBarButtonItemStyle.Done, target: self, action: "expandRight:")
			centerVC.title = "Slide Controller"
			
			let leftVC = UIViewController()
			leftVC.view.backgroundColor = UIColor.redColor()
			
			let rightVC = UIViewController()
			rightVC.view.backgroundColor = UIColor.blueColor()
			
			slideViewController = SlideController(centerViewController: centerNavi, leftViewController: leftVC, rightViewController: rightVC)
			slideViewController.animationDuration = 0.5
			slideViewController.springDampin = 1.0
			
			self.presentViewController(slideViewController, animated: true, completion: nil)
			
		default:
			break
		}
	}
	
	func expandLeft(sender: AnyObject) {
		slideViewController.toggleLeftViewController()
	}
	
	func expandRight(sender: AnyObject) {
		slideViewController.toggleRightViewController()
	}
}
