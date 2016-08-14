//
//  UITestsSection.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-13.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct UITestsSection: TableViewSectionType {
    var headerTitle: String? = "UI Tests"
    var footerTitle: String? = nil
    var shouldShowIndex: Bool = false
    var rows: [TableViewRowType] = {
        return [
            
            TableViewRow(title: "TableViewCell Selection Action Test",
                cellSelectAction: { (indexPath, cell) -> Void in
                    // Test accessing tableView
                    guard let tableView = cell?.tableView else { return }
                    
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
                    let label = UILabel()
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = "👍🏼"
                    
                    cell.addSubview(label)
                    label.constrain(.CenterY, equalTo: .CenterY, ofView: cell)
                    label.constrain(.Trailing, equalTo: .Trailing, ofView: cell, constant: -16.0)
                }
            )
        ]
    }()
}
