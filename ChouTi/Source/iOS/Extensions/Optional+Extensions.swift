//
//  Optional+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-06-06.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

//    public extension Optional {
//        typealias MessageClosure = () -> String?
//        
//        /**
//         Access optional value with warning message
//         
//         - parameter message: Warning message.
//         
//         - returns: Optional value.
//         */
//        @inline(__always) public func warning(_ message: @autoclosure MessageClosure = nil, file: String = #file, line: Int = #line) -> Wrapped? {
//            if self == nil { print(message() ?? "Warning: [\((file as NSString).lastPathComponent):\(line)] \(Wrapped.self)? is nil") }
//            return self
//        }
//        
//        /**
//         Unwrapp an optional value, with a fatal error message
//         
//         - returns: Unwrapped value
//         */
//        @inline(__always) public func unwrapped(_ message: @autoclosure MessageClosure = nil, file: String = #file, line: Int = #line) -> Wrapped {
//            guard let value = self else { fatalError(message() ?? "[\((file as NSString).lastPathComponent):\(line)] \(Wrapped.self)? is nil") }
//            return value
//        }
//    }
//
//    public extension Optional {
//        /**
//         Attempts to unwrap the optional, and executes the closure if a value exists
//         
//         Ref: https://github.com/ovenbits/Alexandria
//         https://github.com/ovenbits/Alexandria/blob/master/Sources/Optional%2BExtensions.swift
//         
//         - parameter block: The closure to execute if a value is found
//         */
//        public func unwrap(block: (Wrapped) throws -> ()) rethrows {
//            if let value = self {
//                try block(value)
//            }
//        }
//    }
