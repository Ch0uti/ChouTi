//
//  TableLayoutDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-09-14.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

@available(iOS 9.0, *)
class TableLayoutDemoViewController: UIViewController {

	let doneButton = UIButton()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		let tableLayout = TableCollectionViewLayout()
		tableLayout.separatorLineWidth = 0.5
		
		let excelTable = TableCollectionView(frame: CGRectZero, collectionViewLayout: tableLayout)
		excelTable.tableLayoutDataSource = self
		excelTable.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(excelTable)
		
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.setTitle("Done", forState: UIControlState.Normal)
		doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		doneButton.addTarget(self, action: "doneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		view.addSubview(doneButton)
		
		let views = ["excelTable": excelTable, "doneButton": doneButton]
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[excelTable]-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-200-[excelTable]-|", options: [], metrics: nil, views: views)
		
		constraints.append(doneButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor))
		constraints.append(doneButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 100))
		
		NSLayoutConstraint.activateConstraints(constraints)
    }
	
	func doneButtonPressed(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension TableLayoutDemoViewController: TableLayoutDataSource {
	func numberOfColumnsInCollectionView(collectionView: UICollectionView) -> Int {
		return 5
	}
	
	func collectionView(collectionView: UICollectionView, numberOfRowsInColumn column: Int) -> Int {
		return column + 1
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String {
		return "Title123"
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String {
		return "Content456"
	}
}
