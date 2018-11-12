//
//  SlideState.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2018-11-05.
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
