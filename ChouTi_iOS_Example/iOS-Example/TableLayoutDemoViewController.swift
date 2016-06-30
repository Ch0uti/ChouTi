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

	let doneButton = Button(type: .System)

	let columns = Int.random(5, 20)
	var rows = [Int : Int]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		for c in 0 ..< columns {
			rows[c] = Int.random(1, 30)
		}
		
		let excelTable = TextTableCollectionView()
		excelTable.textTableDataSource = self
		excelTable.separatorLineWidth = 0.5
        excelTable.layer.borderColor = UIColor.blackColor().CGColor
        excelTable.layer.borderWidth = 0.5
		
		excelTable.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(excelTable)
		
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.setTitle("Done", forState: UIControlState.Normal)
		doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		doneButton.addTarget(self, action: #selector(TableLayoutDemoViewController.doneButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		view.addSubview(doneButton)
		
		let views = ["excelTable": excelTable, "doneButton": doneButton]
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[excelTable]-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-100-[excelTable]-16-|", options: [], metrics: nil, views: views)
		
		constraints.append(doneButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor))
		constraints.append(doneButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 40))
		
		NSLayoutConstraint.activateConstraints(constraints)
    }
	
	func doneButtonPressed(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension TableLayoutDemoViewController : TextTableCollectionViewDataSource {
	func numberOfColumnsInTableCollectionView(tableCollectionView: TextTableCollectionView) -> Int {
		return columns
	}
	
	func tableCollectionView(tableCollectionView: TextTableCollectionView, numberOfRowsInColumn column: Int) -> Int {
		return rows[column]!
	}
	
	func tableCollectionView(tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String {
		return "Title: \(column)"
	}
	
	func tableCollectionView(tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String {
        return "Content: (\(row),\(column))"
	}
}
