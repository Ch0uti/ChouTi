//
//  TableLayoutDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-09-14.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class TableLayoutDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		let tableLayout = TableCollectionViewLayout()
		tableLayout.separatorLineWidth = 0.5
		
		let excelTable = TableCollectionView(frame: CGRectZero, collectionViewLayout: tableLayout)
		excelTable.tableLayoutDataSource = self
		excelTable.setTranslatesAutoresizingMaskIntoConstraints(false)
		view.addSubview(excelTable)
		
		let views = ["excelTable": excelTable]
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[excelTable]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-200-[excelTable]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		NSLayoutConstraint.activateConstraints(constraints)
    }
}

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
