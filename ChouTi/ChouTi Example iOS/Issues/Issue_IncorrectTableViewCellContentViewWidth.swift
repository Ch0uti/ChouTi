//
//  Issue_IncorrectTableViewCellContentViewWidth.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-11-21.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import ChouTi

class Issue_IncorrectTableViewCellContentViewWidth: UIViewController {
	let cell = UITableViewCell()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		cell.backgroundColor = UIColor.red
		cell.contentView.backgroundColor = UIColor.blue
		
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Foo Barrrr"
		
		cell.contentView.addSubview(label)
		NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label" : label]).activate()
		
		cell.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cell)
		cell.constrainTo(width: 200)
		cell.constrainTo(height: 44)
		cell.constrainToCenterInSuperview()
	}
}
