//
//  DummyViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class DummyViewController: UIViewController {
    
    let label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = UIColor.white
        return $0
    }(UILabel())
    
    convenience init(label: String) {
        self.init()
        self.label.text = label
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.isUserInteractionEnabled = true

        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20).isActive = true
		
		var section = TableViewSection(headerTitle: "Test TableView",
		                               rows: [
										TableViewRow(title: ".Value1 Cell",
										             subtitle: "Detail Text",
										             cellInitialization: { indexPath, tableView in
														return tableView.dequeueReusableCell(withClass: TableViewCellValue1.self, forIndexPath: indexPath)
										}),
										TableViewRow(title: ".Value2 Cell",
										             subtitle: "Detail Text",
										             cellInitialization: { indexPath, tableView in
														return tableView.dequeueReusableCell(withClass: TableViewCellValue2.self, forIndexPath: indexPath)
										}),
										TableViewRow(title: "Default Cell",
										             subtitle: "By default Cell Style is .Subtitle"
										)]
		)
		
		section.footerTitle = "This table view is used for testing user interaction in page child view controller."
		
        tableView.sections = [section]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(label.text!): viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(label.text!): viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(label.text!): viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(label.text!): viewDidDisappear")
    }
}
