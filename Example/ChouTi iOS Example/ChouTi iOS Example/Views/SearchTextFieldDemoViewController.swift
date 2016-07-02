//
//  SearchTextFieldDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-03-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class SearchTextFieldDemoViewController : UIViewController {
    
    let searchField = SearchTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorPalette.slackSidebarBackgroundColor
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        
        searchField.backgroundColor = UIColor.whiteColor()
        
        searchField.searchTextFieldDataSource = self
        
        searchField.constrainToSize(CGSize(width: 200, height: 44))
        NSLayoutConstraint(item: searchField, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: searchField, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -200).active = true
    }
}

extension SearchTextFieldDemoViewController : SearchTextFieldDataSource {
    func numberOfResults(forQueryString queryString: String?, inSearchTextField searchTextField: SearchTextField) -> Int {
        return 10
    }
    
    func resultString(forIndex index: Int, inSearchTextField searchTextField: SearchTextField) -> String {
        return "Results"
    }
    
    func resultAttributedString(forIndex index: Int, inSearchTextField searchTextField: SearchTextField) -> NSAttributedString? {
        return nil
    }
    
    func configure(forResultCell resultCell: UITableViewCell, forIndex index: Int, inSearchTextField searchTextField: SearchTextField) {
        //
    }
}
