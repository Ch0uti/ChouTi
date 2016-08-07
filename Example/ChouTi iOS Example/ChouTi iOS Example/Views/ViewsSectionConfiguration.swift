//
//  ViewsSectionConfiguration.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-01.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

struct ViewsSectionConfiguration {
    let section: TableViewSectionType
    
    init(tableView: UITableView) {
        var rows: [TableViewRowType] = []
        
        rows.append(
            TableViewRow(title: "Menu View",
                subtitle: "Horizontal Menu View",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = MenuViewDemoController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "📷 Image Picker",
                subtitle: "Image Selection View",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = ImagePickerDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Drop Down Menu",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = DropDownMenuDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "📅 Date Picker",
                subtitle: "A Slide Up Date Picker View Controller",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = DatePickerControllerDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Navigation Bar with Status Bar",
                subtitle: "Drop down style status bar under navigation bar",
                cellSelectAction: { (indexPath, cell) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = NavigationBarStatusBarDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Search Text Field",
                cellSelectAction: { (indexPath, cell) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = SearchTextFieldDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "⚠️ Alert Controller",
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = AlertControllerDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Page Control",
                subtitle: "Custom PageControl",
                cellSelectAction: { (indexPath, cell) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = PageControlDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        section = TableViewSection(headerTitle: "Views", rows: rows)
    }
}
