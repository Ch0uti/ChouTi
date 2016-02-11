//
//  TableViewCellInfo.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

// Use `class` instead of `static` to let subclass override class method
// Reference: http://stackoverflow.com/questions/29636633/static-vs-class-functions-variables-in-swift-classes

public protocol TableViewRegistrable {
    /**
     Default estimated height
     Sample: return Height
     
     - returns: estimated height
     */
    static func estimatedHeight() -> CGFloat
    
    /**
     Default cell reuse identifier for cell
     Sample: return String(self)
     
     - returns: a cell reuse identifier
     */
    static func identifier() -> String
    
    /**
     Register in table view helper methods
     Sample: tableView.registerClass(self, forCellReuseIdentifier: identifier())
     
     - parameter tableView: target table view to use this cell
     */
    static func registerInTableView(tableView: UITableView)
}

public protocol TableViewCellRegistrable: TableViewRegistrable {
	
}

public protocol TableViewHeaderFooterViewRegistrable: TableViewRegistrable {
    
}



// Sample Implementation:

// MARK: - TableViewCellRegistrable
//extension <#TableViewCell#> : TableViewCellRegistrable {
//	public class func identifier() -> String {
//		return String(self)
//	}
//	
//	public class func estimatedHeight() -> CGFloat {
//		return 44.0
//	}
//	
//	public class func registerInTableView(tableView: UITableView) {
//		tableView.registerClass(self, forCellReuseIdentifier: identifier())
//	}
//}

public extension UITableView {
    func dequeueReusableCell<T: TableViewRegistrable>(withClass `class`: T.Type) -> T? {
        return dequeueReusableCellWithIdentifier(`class`.identifier()) as? T
    }
    
    func dequeueReusableCell<T: TableViewRegistrable>(withClass `class`: T.Type, forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(`class`.identifier(), forIndexPath: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.identifier()) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
    func dequeueResuableHeaderFooterView<T: TableViewHeaderFooterViewRegistrable>(withClass `class`: T.Type) -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(`class`.identifier()) as? T
    }
}
