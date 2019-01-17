//
//  Created by Honghao Zhang on 12/14/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

open class TableViewCellValue1: TableViewCell {
	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
