//
//  TableViewCellSubtitle.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import UIKit

public class TableViewCellSubtitle : TableViewCell {
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
