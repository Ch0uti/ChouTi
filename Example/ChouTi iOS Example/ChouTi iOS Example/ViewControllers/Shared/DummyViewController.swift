//
//  DummyViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi
import Then

extension TableViewSection : Then {}

class DummyViewController: UIViewController {
    
    let label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFontOfSize(24)
        $0.textColor = UIColor.whiteColor()
        return $0
    }(UILabel())
    
    convenience init(label: String) {
        self.init()
        self.label.text = label
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.random()
        view.addSubview(label)
        label.constrainToCenterInSuperview()
        
        let tableView = UITableView(frame: .zero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.userInteractionEnabled = true

        tableView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -20).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(label.topAnchor, constant: -20).active = true
        
        tableView.sections = [
            TableViewSection(headerTitle: "Test TableView",
                rows: [
                    TableViewRow(title: ".Value1 Cell",
                        subtitle: "Detail Text",
                        cellInitialization: { indexPath in
                            return tableView.dequeueReusableCell(withClass: TableViewCellValue1.self, forIndexPath: indexPath)
                        },
                        tableView: tableView
                    ),
                    TableViewRow(title: ".Value2 Cell",
                        subtitle: "Detail Text",
                        cellInitialization: { indexPath in
                            return tableView.dequeueReusableCell(withClass: TableViewCellValue2.self, forIndexPath: indexPath)
                        },
                        tableView: tableView
                    ),
                    TableViewRow(title: "Default Cell",
                        subtitle: "By default Cell Style is .Subtitle",
                        tableView: tableView
                    )
                ],
                tableView: tableView
                ).then {
                    $0.footerTitle = "This table view is used for testing user interaction in page child view controller."
            }
        ]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(label.text!): viewWillAppear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(label.text!): viewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(label.text!): viewWillDisappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(label.text!): viewDidDisappear")
    }
}
