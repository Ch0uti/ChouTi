//
//  IssuesSectionConfiguration.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-05.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct IssuesSectionConfiguration {
    let section: TableViewSectionType
    
    init(tableView: UITableView) {
        var rows: [TableViewRowType] = []
        
        rows.append(
            TableViewRow(title: "Issue: `layoutMarginsGuide`",
                subtitle: "layoutMarginsGuide.topAnchor is not same as .TopMargin",
                tableView: tableView,
                cellSelectAction: { (indexPath, cell) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = IssueLayoutMarginsGuideViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        section = TableViewSection(headerTitle: "Issues", rows: rows, tableView: tableView)
    }
}
