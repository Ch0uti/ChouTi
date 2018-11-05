//
//  TableViewCellSubtitle.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import UIKit

open class TableViewCellSubtitle: TableViewCell {
	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
