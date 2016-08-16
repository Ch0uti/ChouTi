//
//  TableViewCellsDemoVC.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-15.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit
import ChouTi

class TableViewCellsDemoVC: UIViewController {
    let tableView = UITableView()
    
    lazy var swipeCellRow: TableViewRow = {
        return TableViewRow(title: "SwipeTableViewCell",
                            subtitle: "Cell with swipe actions",
                            cellInitialization: { [unowned self] indexPath -> UITableViewCell in
                                let swipeCell = self.tableView.dequeueReusableCell(withClass: SwipeTableViewCell.self, forIndexPath: indexPath)
                                swipeCell.contentView.constrainTo(height: 60.0)
                                
                                // Add label
                                let textLabel = UILabel()
                                textLabel.translatesAutoresizingMaskIntoConstraints = false
                                swipeCell.swipeableContentView.addSubview(textLabel)
                                textLabel.text = "SwipeTableViewCell"
                                textLabel.leadingAnchor.constrainTo(anchor: swipeCell.swipeableContentView.leadingAnchor, constant: swipeCell.indentationWidth * CGFloat(swipeCell.indentationLevel + 2))
                                textLabel.centerYAnchor.constrainTo(anchor: swipeCell.centerYAnchor)
                                
                                // Setup swipe accessory view
                                let accessory = UIView()
                                swipeCell.rightSwipeAccessoryView = accessory
                                accessory.backgroundColor = UIColor.blueColor()
                                accessory.heightAnchor.constrainTo(anchor: swipeCell.swipeableContentView.heightAnchor)
                                accessory.constrainTo(width: 100)
								
								let button = Button()
								button.translatesAutoresizingMaskIntoConstraints = false
								button.setTitle("Hola", forState: .Normal)
								button.setTitleColor(.whiteColor(), forState: .Normal)
								button.addTarget(controlEvents: .TouchUpInside, action: { button in
                                    swipeCell.collapse(animated: true)
                                })
								accessory.addSubview(button)
								button.constrainToCenterInSuperview()
                                
                                return swipeCell
            },
                            cellConfiguration: { _ in },
                            cellSelectAction: { (indexPath, cell) in
                                cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
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
