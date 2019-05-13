// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

open class TableViewCellSubtitle: TableViewCell {
    public override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
