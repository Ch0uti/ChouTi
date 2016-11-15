//
//  UITableView+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-16.
//
//

import UIKit

public extension UITableView {
    /**
     Clear selected index pathes
     
     - parameter animated: whether the deselection is animated
     */
    public func clearSelectedIndexPaths(animated: Bool) {
        guard let selectedIndexPaths = indexPathsForSelectedRows else {
            return
        }
        
        selectedIndexPaths.forEach { [unowned self] in
            self.deselectRow(at: $0, animated: animated)
        }
    }
}
