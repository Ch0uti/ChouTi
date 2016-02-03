//
//  NSRegularExpression+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import Foundation

public extension NSRegularExpression {
    
    public class func tabRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\t)+", options: [])
    }
    
    public class func newlineRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\r\\n|\\r|\\n)+", options: [])
    }
    
    public class func whiteSpaceRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\s)+", options: [])
    }
    
    public class func tabNewlineSpaceRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "(\\r\\n|\\r|\\n|\\t| )+", options: [])
    }
    
    public class func whiteSpacesExceptLastOne() -> NSRegularExpression {
        // References
        // http://stackoverflow.com/questions/16203365/python-regex-matching-all-but-last-occurance
        // http://stackoverflow.com/questions/8668591/regular-expression-all-characters-except-last-one
        
        let whiteSpacePattern = "(\\r\\n|\\r|\\n|\\t| )"
        
        return try! NSRegularExpression(pattern: "\(whiteSpacePattern)+(?=\(whiteSpacePattern)*\(whiteSpacePattern){1})", options: [])
    }
    
    public class func percentNumberRegex() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "([\\d|.])+(?=%)", options: [])
    }
}
