//
//  Created by Honghao Zhang on 10/28/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension NSRegularExpression {
    class func whitespacesExceptLastOne() -> NSRegularExpression {
        // References
        // http://stackoverflow.com/questions/16203365/python-regex-matching-all-but-last-occurance
        // http://stackoverflow.com/questions/8668591/regular-expression-all-characters-except-last-one

        let whitespacesPattern = "(\\t|\\r\\n|\\r|\\n| )"
        return try! NSRegularExpression(pattern: "\(whitespacesPattern)+(?=\(whitespacesPattern)*\(whitespacesPattern){1})", options: [])
    }
}
