// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

// Use `class` instead of `static` to let subclass override class method
// Reference: http://stackoverflow.com/questions/29636633/static-vs-class-functions-variables-in-swift-classes

/**
 *  Table View Meta Info
 */
public protocol TableViewMetaInfo {
    /**
     Default estimated height
     Sample: return Height

     - returns: estimated height
     */
    static func estimatedHeight() -> CGFloat
}

/**
 *  Table View Registrable
 */
public protocol TableViewRegistrable {
    /**
     Default cell reuse identifier for cell
     Sample: return String(self)

     - returns: a cell reuse identifier
     */
    static func identifier() -> String

    /**
     Register cell in table view
     Sample: tableView.registerClass(self, forCellReuseIdentifier: identifier())

     - parameter tableView: target table view to use this cell
     */
    static func registerInTableView(_ tableView: UITableView)

    /**
     Register cell with nib in table view
     Sample: tableView.registerClass(aNib, forCellReuseIdentifier: identifier())

     - parameter nib:       A nib object that specifies the nib file to use to create the cell.
     - parameter tableView: target table view to use this cell
     */
    static func registerNib(_ nib: UINib, inTableView tableView: UITableView)

    /**
     Unregister cell in table view

     - parameter tableView: table view registered this cell
     */
    static func unregisterInTableView(_ tableView: UITableView)

    /**
     Unregister cell with nib in table view

     - parameter tableView: table view registered this cell
     */
    static func unregisterNibInTableView(_ tableView: UITableView)
}

/**
 *  TableViewCell + Registrable
 */
public protocol TableViewCellRegistrable: TableViewMetaInfo, TableViewRegistrable {}

// MARK: - TableViewCellRegistrable

extension UITableViewCell: TableViewCellRegistrable {
    @objc
    open class func estimatedHeight() -> CGFloat {
        return 44.0
    }

    open class func identifier() -> String {
        return String(describing: self)
    }

    open class func registerInTableView(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier())
    }

    open class func registerNib(_ nib: UINib, inTableView tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier())
    }

    open class func unregisterInTableView(_ tableView: UITableView) {
        tableView.register(nil as AnyClass?, forCellReuseIdentifier: identifier())
    }

    open class func unregisterNibInTableView(_ tableView: UITableView) {
        tableView.register(nil as UINib?, forCellReuseIdentifier: identifier())
    }
}

/**
 *  TableViewHeaderFooterView + Registrable
 */
public protocol TableViewHeaderFooterViewRegistrable: TableViewMetaInfo, TableViewRegistrable {}

// MARK: - TableViewHeaderFooterViewRegistrable

extension UITableViewHeaderFooterView: TableViewHeaderFooterViewRegistrable {
    open class func estimatedHeight() -> CGFloat {
        return 22.0
    }

    open class func identifier() -> String {
        return String(describing: self)
    }

    open class func registerInTableView(_ tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: identifier())
    }

    open class func registerNib(_ nib: UINib, inTableView tableView: UITableView) {
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier())
    }

    open class func unregisterInTableView(_ tableView: UITableView) {
        tableView.register(nil as AnyClass?, forHeaderFooterViewReuseIdentifier: identifier())
    }

    open class func unregisterNibInTableView(_ tableView: UITableView) {
        tableView.register(nil as UINib?, forHeaderFooterViewReuseIdentifier: identifier())
    }
}

// MARK: - Cell Registration + Dequeuing

extension UITableView {
    /**
     Register cell with class type

     - parameter `class`: table view cell class which conforms TableViewCellRegistrable.
     */
    open func register<T: TableViewCellRegistrable>(cellClass class: T.Type) {
        `class`.registerInTableView(self)
    }

    /**
     Register cell with nib and class type

     - parameter nib:     A nib object that specifies the nib file to use to create the cell.
     - parameter `class`: table view cell class which conforms TableViewCellRegistrable.
     */
    open func register<T: TableViewCellRegistrable>(_ nib: UINib, forClass class: T.Type) {
        `class`.registerNib(nib, inTableView: self)
    }

    /**
     Dequeue a Reusable Cell in a way that provides type information.

     If you are going to use this dequeue method it is recomended that you use `register<T: TableViewCellRegistrable>(cellClass: T.Type)` or
     `register<T: TableViewCellRegistrable>(nib: UINib, forClass: T.Type)` for registration.

     - parameter `class`: The class whose type you are dequeing.

     - returns: Returns a view of the type requested if it was registered, `nil` otherwise.
     */

    open func dequeueReusableCell<T: TableViewCellRegistrable>(withClass class: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: `class`.identifier()) as? T
    }

    /**
     Dequeue a Reusable Cell in a way that provides type information.

     This call will raise a fatal error if the cell was not registered with `identifier()`.
     This behaviour is not particularily different from the method which it is covering,
     `dequeueReusableCellWithIdentifier` which will raise an NSInternalInconsistency Exception
     because the cell was not registered with the corrrect identifier or at all.

     If you are going to use this dequeue method it is recomended that you use `register<T: TableViewCellRegistrable>(cellClass: T.Type)` or `register<T: TableViewCellRegistrable>(nib: UINib, forClass: T.Type)` for registration.

     - parameter `class`:   The class whose type you are dequeing.
     - parameter indexPath: The index path of the cell you want to dequeue.

     - returns: Returns a cell of the type requested.
     */
    open func dequeueReusableCell<T: TableViewCellRegistrable>(withClass class: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: `class`.identifier(), for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.identifier()) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}

// MARK: - HeaderFooterView Registration + Dequeuing

extension UITableView {
    /**
     Register Header/Footer view with class type

     - parameter `class`: header/footer view class which conforms TableViewHeaderFooterViewRegistrable.
     */
    open func register<T: TableViewHeaderFooterViewRegistrable>(headerFooterClass class: T.Type) {
        `class`.registerInTableView(self)
    }

    /**
     Register Header/Footer view with nib and class type

     - parameter nib:     A nib object that specifies the nib file to use to create the header or footer view.
     - parameter `class`: header/footer view class which conforms TableViewHeaderFooterViewRegistrable.
     */
    open func register<T: TableViewHeaderFooterViewRegistrable>(_ nib: UINib, forHeaderFooterClass class: T.Type) {
        `class`.registerNib(nib, inTableView: self)
    }

    /**
     Dequeue a Header/Footer View in a way that provides type information.

     If you are going to use this dequeue method it is recomended that you use `register<T: TableViewHeaderFooterViewRegistrable>(headerFooterClass `class`: T.Type)` or
     `register<T: TableViewHeaderFooterViewRegistrable>(nib: UINib, forHeaderFooterClass `class`: T.Type)` for registration.

     - parameter `class`: The class whose type you are dequeing.

     - returns: Returns a view of the type requested if it was registered, `nil` otherwise.
     */
    open func dequeueResuableHeaderFooterView<T: TableViewHeaderFooterViewRegistrable>(withClass class: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: `class`.identifier()) as? T
    }
}
