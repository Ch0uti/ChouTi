//
//  TableViewCellValue2.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import UIKit

open class TableViewCellValue2: TableViewCell {
	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value2, reuseIdentifier: reuseIdentifier)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
