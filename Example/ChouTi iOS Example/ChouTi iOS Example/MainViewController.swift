//
//  MainViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MainViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().delegate?.window??.tintColor = UIColor(red:252/255.0, green:43/255.0, blue:27/255.0, alpha:255/255.0)
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
            ViewsSectionConfiguration(tableView: tableView).section,
            ViewControllersSectionConfiguration(tableView: tableView).section,
            MiscellaneousSectionConfiguration(tableView: tableView).section
        ]
    }
}
