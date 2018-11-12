//
//  UITableViewCell+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-14.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UITableViewCell {

    /**
     Enable full width separtor for UITableViewCell
     Note: This will mutate separtor inset and layout margins, call this method carefully
     */
    func enableFullWidthSeparator() {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}

// MARK: - Access `tabelView` in UITableView
public extension UITableViewCell {
    /// Return tableView managing this cell
    var tableView: UITableView? {
		return superview(ofType: UITableView.self)
	}
}
