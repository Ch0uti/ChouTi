//
//  SearchTextFieldDemoViewController.swift
//  iOS-Example
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
        
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        
        searchField.backgroundColor = UIColor.whiteColor()
        
        searchField.searchTextFieldDataSource = self
        
        searchField.constraintToSize(CGSize(width: 200, height: 44))
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
