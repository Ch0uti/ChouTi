//
//  UITestsSection.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-13.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import ChouTi
import Foundation

struct UITestsSection: TableViewSectionType {
    var headerTitle: String? = "UI Tests"
    var rows: [TableViewRowType] = {
        return [
            TableViewRow(title: "TableViewCell Selection Action Test",
                         cellSelectAction: { indexPath, cell, tableView -> Void in
                            // Test accessing tableView
                            guard let tableView = cell?.tableView else { return }

                            tableView.deselectRow(at: indexPath, animated: true)

                            guard let cell = tableView.cellForRow(at: indexPath) else { return }
                            let label = UILabel()
                            label.translatesAutoresizingMaskIntoConstraints = false
                            label.text = "👍🏼"

                            cell.addSubview(label)
                            label.constrain(.centerY, equalTo: .centerY, ofView: cell)
                            label.constrain(.trailing, equalTo: .trailing, ofView: cell, constant: -16.0)
            }
            )
        ]
    }()
}
