//
//  MainViewController.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-13.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

class MainViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .Grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.clipsToBounds = true
        navigationController?.view.layer.cornerRadius = 8.0
        
        title = "🗄 抽屉(ChouTi)"
        navigationController?.navigationBar.titleTextColor = UIColor(red:252/255.0, green:43/255.0, blue:27/255.0, alpha:255/255.0)
        navigationController?.navigationBar.titleTextFont = UIFont.boldSystemFontOfSize(18)
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.constrainToFullSizeInSuperview()
        
        tableView.sections = [
            ViewsSection(),
            ViewControllersSection(),
            MiscellaneousSection(),
            IssuesSection(),
            UITestsSection()
        ]
    }
}
