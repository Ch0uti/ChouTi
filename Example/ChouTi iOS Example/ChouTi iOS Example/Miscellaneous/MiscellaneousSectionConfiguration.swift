//
//  MiscellaneousSectionConfiguration.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-01.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct MiscellaneousSectionConfiguration {
    let section: TableViewSectionType
    init(tableView: UITableView) {
        var rows: [TableViewRowType] = []
        
        rows.append(
            TableViewRow(title: "Drop Presenting Animator",
                subtitle: "Path style drop down presenting",
                cellSelectAction: { (indexPath, cell) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = DropPresentingDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "├┼┤ Table (Grid) Layout",
                subtitle: "Excel Layout",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = TableLayoutDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Navigation Bar Hide Hairline",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = HideNavigationBarBottomLineDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "TableView+SectionRow Demo",
                subtitle: "Demo for handy table view sections and rows management",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = TableViewSectionRowExtensionDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "Operations",
                subtitle: "Demo for using Operations (NSOperations)",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = OperationsDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "Auto Layout: Leading/Trailing vs. Left/Right",
                subtitle: "Demo for Leading vs Trailing",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = LeadingTrailingVSLeftRightDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "UIImage+Extensions Demo",
                subtitle: "Demo for UIImage extensions",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = UIImageExtensionsDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
            })
        )
        
        section = TableViewSection(headerTitle: "Miscellaneous", rows: rows)
    }
}
