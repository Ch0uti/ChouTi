// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import Foundation

struct MiscellaneousSection: TableViewSectionType {
    var headerTitle: String? = "Miscellaneous"

    var rows: [TableViewRowType] = {
        [
            TableViewRow(
                title: "Drop Presenting Animator",
                subtitle: "Path style drop down presenting",
                cellSelectAction: { indexPath, cell, _ -> Void in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(DropPresentingDemoViewController(), sender: nil)
                }
            ),

            TableViewRow(
                title: "├┼┤ Table (Grid) Layout",
                subtitle: "Excel Layout",
                cellSelectAction: { indexPath, cell, _ in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(TableLayoutDemoViewController(), sender: nil)
                }
            ),

            TableViewRow(
                title: "Navigation Bar Hide Hairline",
                cellSelectAction: { indexPath, cell, _ in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(HideNavigationBarBottomLineDemoViewController(), sender: nil)
                }
            ),

            TableViewRow(
                title: "TableView+SectionRow Demo",
                subtitle: "Demo for handy table view sections and rows management",
                cellSelectAction: { indexPath, cell, _ in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(TableViewSectionRowExtensionDemoViewController(), sender: nil)
                }
            ),

            TableViewRow(
                title: "Auto Layout: Leading/Trailing vs. Left/Right",
                subtitle: "Demo for Leading vs Trailing",
                cellSelectAction: { indexPath, cell, _ in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(LeadingTrailingVSLeftRightDemoViewController(), sender: nil)
                }
            ),

            TableViewRow(
                title: "UIImage+Extensions Demo",
                subtitle: "Demo for UIImage extensions",
                cellSelectAction: { indexPath, cell, _ in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(UIImageExtensionsDemoViewController(), sender: nil)
                }
            ),
        ]
    }()
}
