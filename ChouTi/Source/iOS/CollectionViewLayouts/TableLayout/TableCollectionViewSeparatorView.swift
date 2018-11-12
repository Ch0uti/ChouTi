//
//  Created by Honghao Zhang on 03/01/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

class TableCollectionViewSeparatorView: UICollectionReusableView {
    static var separatorColor = UIColor(white: 0.5, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = TableCollectionViewSeparatorView.separatorColor
    }
}
