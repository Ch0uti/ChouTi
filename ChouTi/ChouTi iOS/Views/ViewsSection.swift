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
    
    var rows: [TableViewRowType] = {
        return [
            TableViewRow(title: "Menu View",
                subtitle: "Horizontal Menu View",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(MenuViewDemoController(), sender: nil)
                }
            ),
            TableViewRow(title: "📷 Image Picker",
                subtitle: "Image Selection View",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(ImagePickerDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "Drop Down Menu",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(DropDownMenuDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "📅 Date Picker",
                subtitle: "A Slide Up Date Picker View Controller",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(DatePickerControllerDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "Navigation Bar with Status Bar",
                subtitle: "Drop down style status bar under navigation bar",
                cellSelectAction: { (indexPath, cell, tableView) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(NavigationBarStatusBarDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "Search Text Field",
                cellSelectAction: { (indexPath, cell, tableView) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(SearchTextFieldDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "⚠️ Alert Controller",
                cellSelectAction: { indexPath, cell, tableView in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(AlertControllerDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "Page Control",
                subtitle: "Custom PageControl",
                cellSelectAction: { (indexPath, cell, tableView) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(PageControlDemoViewController(), sender: nil)
                }
            ),
            TableViewRow(title: "TableViewCells Demo",
                subtitle: "Various TableViewCells in ChouTi",
                cellSelectAction: { (indexPath, cell, tableView) -> Void in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(TableViewCellsDemoVC(), sender: nil)
                }
            )
        ]
    }()
}
