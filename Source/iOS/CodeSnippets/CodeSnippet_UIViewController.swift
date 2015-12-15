//
//  CodeSnippet_UIViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-24.
//
//

//import UIKit
//
//class <#ViewController#>: UIViewController {
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		setupViews()
//		setupConstraints()
//	}
//	
//	private func setupViews() {
//		// TODO: Setup view hierarchy
//		<#view#>.translatesAutoresizingMaskIntoConstraints = false
//		view.addSubview(<#view#>)
//	}
//	
//	private func setupConstraints() {
//		// TODO: Setup constraints
//		let views = [
//			"view" : <#view#>
//		]
//		
//		let metrics: [String : CGFloat] = [
//			"vertical_spacing" : 4.0
//		]
//		
//		var constraints = [NSLayoutConstraint]()
//		
//		// TODO: Add constraints
//		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options: [], metrics: metrics, views: views)
//		
//		NSLayoutConstraint.activateConstraints(constraints)
//	}
//}



// MARK: - Detecting Poping or Pushing

//override func viewWillDisappear(animated: Bool) {
//	super.viewWillDisappear(animated)
//	
//	if isMovingFromParentViewController() {
//		// This view controller will be poped
//	} else if isMovingToParentViewController() {
//		// Some View Controller will push onto
//	} else {
//		print("Warning: view controller: \(self) is not poping or being pushed")
//	}
//}
