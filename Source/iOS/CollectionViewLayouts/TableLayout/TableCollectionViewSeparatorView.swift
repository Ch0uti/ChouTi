//
//  TableCollectionViewSeparatorView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

class TableCollectionViewSeparatorView: UICollectionReusableView {
    static var separatorColor = UIColor(white: 0.5, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = TableCollectionViewSeparatorView.separatorColor
    }
}
