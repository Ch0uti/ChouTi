//
//  ViewsSection.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-15.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct ViewsSection: TableViewSectionType {
    var headerTitle: String? = "Views"
    var footerTitle: String? = nil
    var shouldShowIndex: Bool = false
    var rows: [TableViewRowType] = {
        return [
            TableViewRow(title: "TableViewCells Demo",
                subtitle: "Various TableViewCells in ChouTi",
                cellSelectAction: { (indexPath, cell) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(TableViewCellsDemoVC(), sender: nil)
                }
            )
        ]
    }()
}
