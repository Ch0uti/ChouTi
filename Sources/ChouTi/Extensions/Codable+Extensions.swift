// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

// Reference: https://gist.github.com/darrarski/69502f12961629ef049d5f63eb81ac1d
public extension KeyedDecodingContainer {
  /// Decodes a value of the given type for the given key.
  /// - Parameters:
  ///   - type: The type of value to decode.
  ///   - key: The key that the decoded value is associated with.
  /// - Returns: A value of the requested type, if present for the given key and convertible to the requested type.
  func decode(_: Decimal.Type, forKey key: K) throws -> Decimal {
    let string = try decode(String.self, forKey: key)
    guard let decimal = Decimal(string: string) else {
      throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid decimal value (\(string))")
    }
    return decimal
  }
}

public extension KeyedEncodingContainer {
  /// Encodes the given value for the given key.
  /// - Parameters:
  ///   - decimal: The value to encode.
  ///   - key: The key to associate the value with.
  mutating func encode(_ decimal: Decimal, forKey key: K) throws {
    let decimalNumber = NSDecimalNumber(decimal: decimal)
    let string = decimalNumber.stringValue
    try encode(string, forKey: key)
  }
}
