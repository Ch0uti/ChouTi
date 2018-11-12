//
//  SearchTextFieldDemoViewController.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-03-12.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import UIKit

class SearchTextFieldDemoViewController: UIViewController {

    let searchField = SearchTextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorPalette.slackSidebarPurpleColor

        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)

        searchField.backgroundColor = UIColor.white

        searchField.searchTextFieldDataSource = self

        searchField.constrainTo(size: CGSize(width: 200, height: 44))
        NSLayoutConstraint(item: searchField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: searchField, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -200).isActive = true
    }
}

extension SearchTextFieldDemoViewController: SearchTextFieldDataSource {
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
