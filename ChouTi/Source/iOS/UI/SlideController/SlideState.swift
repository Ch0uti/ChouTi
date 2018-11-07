//
//  SlideState.swift
//  ChouTi
//
//  Created by Honghao Zhang on 11/5/18.
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
