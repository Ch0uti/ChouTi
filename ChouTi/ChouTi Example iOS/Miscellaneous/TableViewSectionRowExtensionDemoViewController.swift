//
//  TableViewSectionRowExtensionDemoViewController.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-02.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import UIKit

class TableViewSectionRowExtensionDemoViewController: UIViewController {

    let tableView = UITableView(frame: CGRect.zero, style: {
        (Bool.random() ? .grouped : .plain) }()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TableView+SectionRow"

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		tableView.constrainToFullSizeInSuperview()
        tableView.rowHeight = UITableView.automaticDimension

        tableView.sections = []
        tableView.sections?.append(
            TableViewSection(headerTitle: "Section1",
                             rows:
                [
                    TableViewRow(title: "Cell with .Value1 Style",
                                 subtitle: "Detail Text",
                                 cellInitialization: { _, _ in
                                    var cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier())
                                    if cell == nil {
                                        cell = TableViewCell(style: .value1, reuseIdentifier: TableViewCell.identifier())
                                    }
                                    return cell!
                    }),
                    TableViewRow(title: "Cell with .Value2 Style",
                                 subtitle: "Detail Text",
                                 cellInitialization: { _, _ in
                                    self.tableView.dequeueReusableCell(withIdentifier: TableViewCellValue2.identifier())!
                    }),
                    TableViewRow(title: "Cell with default Style (.Subtitle Style)",
                                 subtitle: "By default Cell Style is .Subtitle"
                    ),
                    TableViewRow(title: "我是一个Cell的主标题",
                                 subtitle: "我是副标题"
                    )
                ]))

        var section2 = TableViewSection(headerTitle: "I'm Section2 Header Text",
                                        rows:
            [
                TableViewRow(title: "Customized Cell",
                             subtitle: "Subtitle...",
                             cellInitialization: { indexPath, tableView -> UITableViewCell in
                                var cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier())
                                if cell == nil {
                                    cell = TableViewCell(style: .subtitle, reuseIdentifier: TableViewCell.identifier())
                                }
                                return cell!
                },
                             cellConfiguration: { indexPath, cell, tableView -> Void in
                                (cell as? TableViewCell)?.cellHeight = 200
                                cell.textLabel?.text = "Click on Me"
                                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)

                                cell.detailTextLabel?.text = "Now height is 200.0, it is calculated by constraints automatically!"
                                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                                cell.detailTextLabel?.numberOfLines = 0
                                cell.backgroundColor = UIColor.random()
                },
                             cellSelectAction: { indexPath, cell, tableView -> Void in
                                self.tableView.deselectRow(at: indexPath, animated: true)
                                cell?.textLabel?.textColor = UIColor.random()
                                cell?.detailTextLabel?.textColor = UIColor.random()
                                cell?.backgroundColor = UIColor.random()
                },
                             cellDeselectAction: { _, _, _ -> Void in
                                //
                }),
                TableViewRow(title: "",
                             cellInitialization: { _, _ -> UITableViewCell in
                                var cell = self.tableView.dequeueReusableCell(withIdentifier: SeparatorCell.identifier())
                                if cell == nil {
                                    cell = TableViewCell(style: .default, reuseIdentifier: SeparatorCell.identifier())
                                }

                                (cell as? SeparatorCell)?.separatorView.backgroundColor = UIColor.red

                                cell?.layoutMargins = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
                                cell?.contentView.layoutMargins = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)

                                // FIXME: Height is not settable

                                return cell!
                })
            ]
        )
        section2.footerTitle = "I'm Section2 Footer Text"

        tableView.sections?.append(section2)
	}
}
