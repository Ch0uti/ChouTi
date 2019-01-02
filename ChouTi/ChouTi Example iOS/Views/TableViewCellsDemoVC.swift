//
//  Created by Honghao Zhang on 8/15/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import UIKit

class TableViewCellsDemoVC: UIViewController {
    let tableView = UITableView()

    lazy var swipeCellRow: TableViewRow = {
        TableViewRow(title: "SwipeTableViewCell",
                     subtitle: "Cell with swipe actions",
                     cellInitialization: { [unowned self] indexPath, tableView -> UITableViewCell in
                        let swipeCell = self.tableView.dequeueReusableCell(withClass: SwipeTableViewCell.self, forIndexPath: indexPath)
                        swipeCell.contentView.constrainTo(height: 60.0)

                        // Add label
                        let textLabel = UILabel()
                        textLabel.translatesAutoresizingMaskIntoConstraints = false
                        swipeCell.swipeableContentView.addSubview(textLabel)
                        textLabel.text = "SwipeTableViewCell"
                        textLabel.leadingAnchor.constrain(to: swipeCell.swipeableContentView.leadingAnchor, constant: swipeCell.indentationWidth * CGFloat(swipeCell.indentationLevel + 2))
                        textLabel.centerYAnchor.constrain(to: swipeCell.centerYAnchor)

                        // Setup swipe accessory view
                        let accessory = UIView()
                        swipeCell.rightSwipeAccessoryView = accessory
                        accessory.backgroundColor = UIColor.blue
                        accessory.heightAnchor.constrain(to: swipeCell.swipeableContentView.heightAnchor)
                        accessory.constrainTo(width: 100)

                        let button = Button()
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.setTitle("Hola", for: .normal)
                        button.setTitleColor(.white, for: .normal)
                        button.addTarget(controlEvents: .touchUpInside, action: { _ in
                            swipeCell.collapse(animated: true)
                        })
                        accessory.addSubview(button)
                        button.constrainToCenterInSuperview()

                        return swipeCell
            },
                     cellConfiguration: { _, _, _ in },
                     cellSelectAction: { indexPath, cell, tableView in
                        cell?.tableView?.deselectRow(at: indexPath, animated: true)
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TableViewCells"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.constrainToFullSizeInSuperview()

        tableView.register(cellClass: SwipeTableViewCell.self)

        tableView.sections = [
            TableViewSection(rows:
                [
                    swipeCellRow,
                    swipeCellRow,
                    swipeCellRow
                ]
            )
        ]
    }
}
