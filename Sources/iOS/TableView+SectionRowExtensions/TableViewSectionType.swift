// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public protocol TableViewSectionType {
    var headerTitle: String? { get set }
    var headerView: ((Int, UITableView) -> UIView?)? { get set }
    var headerHeight: ((Int, UITableView) -> CGFloat)? { get set }
    var headerWillDisplay: ((Int, UIView, UITableView) -> Void)? { get set }

    var footerTitle: String? { get set }
    var footerView: ((Int, UITableView) -> UIView?)? { get set }
    var footerHeight: ((Int, UITableView) -> CGFloat)? { get set }
    var footerWillDisplay: ((Int, UIView, UITableView) -> Void)? { get set }

    var rows: [TableViewRowType] { get set }

    var shouldShowIndex: Bool { get set }
}

// swiftlint:disable unused_setter_value
public extension TableViewSectionType {
    var headerTitle: String? { get { return nil } set {} }
    var headerView: ((Int, UITableView) -> UIView?)? { get { return nil } set {} }
    var headerHeight: ((Int, UITableView) -> CGFloat)? { get { return nil } set {} }
    var headerWillDisplay: ((Int, UIView, UITableView) -> Void)? { get { return nil } set {} }

    var footerTitle: String? { get { return nil } set {} }
    var footerView: ((Int, UITableView) -> UIView?)? { get { return nil } set {} }
    var footerHeight: ((Int, UITableView) -> CGFloat)? { get { return nil } set {} }
    var footerWillDisplay: ((Int, UIView, UITableView) -> Void)? { get { return nil } set {} }

    var rows: [TableViewRowType] { get { return [] } set {} }
    var shouldShowIndex: Bool { get { return false } set {} }
}
