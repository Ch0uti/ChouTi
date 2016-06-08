//
//  Optional+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-06-06.
//
//

import Foundation

public extension Optional {
    typealias MessageClosure = () -> String?
    
    /**
     If this value is nil, post a warning message.
     
     - parameter message: Warning message.
     
     - returns: Same optional type.
     */
    @inline(__always) public func warning(@autoclosure message: MessageClosure = nil) -> Wrapped? {
        if self == nil { print(message() ?? "Warning: [\((#file as NSString).lastPathComponent):\(#line)] \(Wrapped.self)? is nil") }
        return self
    }
    
    /**
     Unwrapp an optional value, with a fatal error message
     
     - returns: Unwrapped value
     */
    @inline(__always) public func unwrapped(@autoclosure message: MessageClosure = nil) -> Wrapped {
        guard let value = self else { fatalError(message() ?? "\(Wrapped.self)? is nil") }
        return value
    }
}
