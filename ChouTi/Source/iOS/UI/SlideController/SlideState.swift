//
//  Created by Honghao Zhang on 11/05/2018.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension SlideController {

    /// The state of slide controller.
    enum SlideState {
        case notExpanded
        case leftExpanding
        case leftExpanded
        case leftCollapsing
        case rightExpanding
        case rightExpanded
        case rightCollapsing
    }
}
