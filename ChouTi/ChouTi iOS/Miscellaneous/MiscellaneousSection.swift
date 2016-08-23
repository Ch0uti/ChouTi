//
//  MiscellaneousSection.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-16.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct MiscellaneousSection: TableViewSectionType {
    var headerTitle: String? = "Miscellaneous"
    var footerTitle: String? = nil
    var shouldShowIndex: Bool = false
    var rows: [TableViewRowType] = {
        return [
            TableViewRow(title: "Drop Presenting Animator",
                subtitle: "Path style drop down presenting",
                cellSelectAction: { (indexPath, cell, tableView) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(DropPresentingDemoViewController(), sender: nil)
                }
            ),
            
            TableViewRow(title: "├┼┤ Table (Grid) Layout",
                subtitle: "Excel Layout",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(TableLayoutDemoViewController(), sender: nil)
                }
            ),
            
            TableViewRow(title: "Navigation Bar Hide Hairline",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(HideNavigationBarBottomLineDemoViewController(), sender: nil)
            }),
            
            TableViewRow(title: "TableView+SectionRow Demo",
                subtitle: "Demo for handy table view sections and rows management",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(TableViewSectionRowExtensionDemoViewController(), sender: nil)
            }),
            
            TableViewRow(title: "Operations",
                subtitle: "Demo for using Operations (NSOperations)",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(OperationsDemoViewController(), sender: nil)
            }),
            
            TableViewRow(title: "Auto Layout: Leading/Trailing vs. Left/Right",
                subtitle: "Demo for Leading vs Trailing",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(LeadingTrailingVSLeftRightDemoViewController(), sender: nil)
            }),
            
            TableViewRow(title: "UIImage+Extensions Demo",
                subtitle: "Demo for UIImage extensions",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(UIImageExtensionsDemoViewController(), sender: nil)
            })
        ]
    }()
}
