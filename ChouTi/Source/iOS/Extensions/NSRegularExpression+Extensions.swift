//
//  NSRegularExpression+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import Foundation

public extension NSRegularExpression {

    class func tabRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\t)+", options: [])
    }

    class func newlineRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\r\\n|\\r|\\n)+", options: [])
    }

    class func whiteSpaceRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\s)+", options: [])
    }

    class func tabNewlineSpaceRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\r\\n|\\r|\\n|\\t| )+", options: [])
    }

    class func whiteSpacesExceptLastOne() -> NSRegularExpression {
        // References
        // http://stackoverflow.com/questions/16203365/python-regex-matching-all-but-last-occurance
        // http://stackoverflow.com/questions/8668591/regular-expression-all-characters-except-last-one

        let whiteSpacePattern = "(\\r\\n|\\r|\\n|\\t| )"

        return try! NSRegularExpression(pattern: "\(whiteSpacePattern)+(?=\(whiteSpacePattern)*\(whiteSpacePattern){1})", options: [])
    }

    class func percentNumberRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "([\\d|.])+(?=%)", options: [])
    }
}
