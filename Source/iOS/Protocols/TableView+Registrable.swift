//
//  TableView+Registrable.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

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
    static func registerInTableView(tableView: UITableView)
    
    /**
     Register cell with nib in table view
     Sample: tableView.registerClass(aNib, forCellReuseIdentifier: identifier())
     
     - parameter nib:       A nib object that specifies the nib file to use to create the cell.
     - parameter tableView: target table view to use this cell
     */
    static func registerNib(nib: UINib, inTableView tableView: UITableView)
    
    /**
     Deregister cell in table view
     
     - parameter tableView: table view registered this cell
     */
    static func deregisterInTableView(tableView: UITableView)
    
    /**
     Deregister cell with nib in table view
     
     - parameter tableView: table view registered this cell
     */
    static func deregisterNibInTableView(tableView: UITableView)
}

/**
 *  TableViewCell + Registrable
 */
public protocol TableViewCellRegistrable: TableViewMetaInfo, TableViewRegistrable {

}

// MARK: - TableViewCellRegistrable
extension UITableViewCell : TableViewCellRegistrable {
    public class func estimatedHeight() -> CGFloat {
        return 44.0
    }
    
    public class func identifier() -> String {
        return String(self)
    }
    
    public class func registerInTableView(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: identifier())
    }
    
    public class func registerNib(nib: UINib, inTableView tableView: UITableView) {
        tableView.registerNib(nib, forCellReuseIdentifier: identifier())
    }
    
    public class func deregisterInTableView(tableView: UITableView) {
        tableView.registerClass(nil, forCellReuseIdentifier: identifier())
    }
    
    public class func deregisterNibInTableView(tableView: UITableView) {
        tableView.registerNib(nil, forCellReuseIdentifier: identifier())
    }
}

/**
 *  TableViewHeaderFooterView + Registrable
 */
public protocol TableViewHeaderFooterViewRegistrable: TableViewMetaInfo, TableViewRegistrable {
    
}

// MARK: - TableViewHeaderFooterViewRegistrable
extension UITableViewHeaderFooterView : TableViewHeaderFooterViewRegistrable {
    public class func estimatedHeight() -> CGFloat {
        return 20.0
    }
    
    public class func identifier() -> String {
        return String(self)
    }
    
    public class func registerInTableView(tableView: UITableView) {
        tableView.registerClass(self, forHeaderFooterViewReuseIdentifier: identifier())
    }
    
    public class func registerNib(nib: UINib, inTableView tableView: UITableView) {
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier())
    }
    
    public class func deregisterInTableView(tableView: UITableView) {
        tableView.registerClass(nil, forHeaderFooterViewReuseIdentifier: identifier())
    }
    
    public class func deregisterNibInTableView(tableView: UITableView) {
        tableView.registerNib(nil, forHeaderFooterViewReuseIdentifier: identifier())
    }
}

// MARK: - Cell Registration + Dequeuing
extension UITableView {
    /**
     Register cell with class type
     
     - parameter `class`: table view cell class which conforms TableViewCellRegistrable.
     */
    public func register<T: TableViewCellRegistrable>(cellClass `class`: T.Type) {
        `class`.registerInTableView(self)
    }
    
    /**
     Register cell with nib and class type
     
     - parameter nib:     A nib object that specifies the nib file to use to create the cell.
     - parameter `class`: table view cell class which conforms TableViewCellRegistrable.
     */
    public func register<T: TableViewCellRegistrable>(nib: UINib, forClass `class`: T.Type) {
        `class`.registerNib(nib, inTableView: self)
    }
    
    /**
     Dequeue a Reusable Cell in a way that provides type information.
     
     If you are going to use this dequeue method it is recomended that you use `register<T: TableViewCellRegistrable>(cellClass: T.Type)` or
     `register<T: TableViewCellRegistrable>(nib: UINib, forClass: T.Type)` for registration.
     
     - parameter `class`: The class whose type you are dequeing.
     
     - returns: Returns a view of the type requested if it was registered, `nil` otherwise.
     */
    
    public func dequeueReusableCell<T: TableViewCellRegistrable>(withClass `class`: T.Type) -> T? {
        return dequeueReusableCellWithIdentifier(`class`.identifier()) as? T
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
    public func dequeueReusableCell<T: TableViewCellRegistrable>(withClass `class`: T.Type, forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(`class`.identifier(), forIndexPath: indexPath) as? T else {
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
    public func register<T: TableViewHeaderFooterViewRegistrable>(headerFooterClass `class`: T.Type) {
        `class`.registerInTableView(self)
    }
    
    /**
     Register Header/Footer view with nib and class type
     
     - parameter nib:     A nib object that specifies the nib file to use to create the header or footer view.
     - parameter `class`: header/footer view class which conforms TableViewHeaderFooterViewRegistrable.
     */
    public func register<T: TableViewHeaderFooterViewRegistrable>(nib: UINib, forHeaderFooterClass `class`: T.Type) {
        `class`.registerNib(nib, inTableView: self)
    }
    
    /**
     Dequeue a Header/Footer View in a way that provides type information.
     
     If you are going to use this dequeue method it is recomended that you use `register<T: TableViewHeaderFooterViewRegistrable>(headerFooterClass `class`: T.Type)` or
     `register<T: TableViewHeaderFooterViewRegistrable>(nib: UINib, forHeaderFooterClass `class`: T.Type)` for registration.
     
     - parameter `class`: The class whose type you are dequeing.
     
     - returns: Returns a view of the type requested if it was registered, `nil` otherwise.
     */
    public func dequeueResuableHeaderFooterView<T: TableViewHeaderFooterViewRegistrable>(withClass `class`: T.Type) -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(`class`.identifier()) as? T
    }
}
