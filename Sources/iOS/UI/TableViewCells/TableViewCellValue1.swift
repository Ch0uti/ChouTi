// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

open class TableViewCellValue1: TableViewCell {
    public override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
