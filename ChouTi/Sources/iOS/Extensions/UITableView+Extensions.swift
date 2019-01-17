//
//  Created by Honghao Zhang on 12/16/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UITableView {
    /**
     Clear selected index pathes
     
     - parameter animated: whether the deselection is animated
     */
    func clearSelectedIndexPaths(animated: Bool) {
        guard let selectedIndexPaths = indexPathsForSelectedRows else {
            return
        }

        selectedIndexPaths.forEach { [unowned self] in
            self.deselectRow(at: $0, animated: animated)
        }
    }
}
