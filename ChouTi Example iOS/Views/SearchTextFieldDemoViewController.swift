// Copyright © 2019 ChouTi. All rights reserved.

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
    func numberOfResults(forQueryString _: String?, inSearchTextField _: SearchTextField) -> Int {
        return 10
    }

    func resultString(forIndex _: Int, inSearchTextField _: SearchTextField) -> String {
        return "Results"
    }

    func resultAttributedString(forIndex _: Int, inSearchTextField _: SearchTextField) -> NSAttributedString? {
        return nil
    }

    func configure(forResultCell _: UITableViewCell, forIndex _: Int, inSearchTextField _: SearchTextField) {
        //
    }
}
