// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import Foundation

struct IssuesSection: TableViewSectionType {
    var headerTitle: String? = "Issues"
    var rows: [TableViewRowType] = {
        [
            TableViewRow(
                title: "Issue: `layoutMarginsGuide`",
                subtitle: "layoutMarginsGuide.topAnchor is not same as .TopMargin",
                cellSelectAction: { indexPath, cell, _ -> Void in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(Issue_LayoutMarginsGuideViewController(), sender: nil)
                }
            ),
            TableViewRow(
                title: "Issue: `preservesSuperviewLayoutMargins`",
                subtitle: "Demo for `preservesSuperviewLayoutMargins`",
                cellSelectAction: { indexPath, cell, _ -> Void in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(Issue_PreservesSuperviewLayoutMargins(), sender: nil)
                }
            ),
            TableViewRow(
                title: "Issue: TableViewCell contentView 0 width.",
                cellSelectAction: { indexPath, cell, _ -> Void in
                    cell?.tableView?.deselectRow(at: indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.show(Issue_IncorrectTableViewCellContentViewWidth(), sender: nil)
                }
            ),
        ]
    }()
}
