// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

public extension Decimal {
    /// Returns a rounded version of the decimal number using plain rounding mode and 2 fraction digits.
    var rounded: Decimal {
        return rounded(roundingMode: .plain, scale: 2)
    }

    /// Returns a rounded version of the decimal number using the specified rounding specification.
    ///
    /// - Parameters:
    ///   - roundingMode: The rounding mode to use.
    ///   - scale: The number of digits a rounded value should have after its decimal point.
    /// - Returns: A rounded version of the decimal number.
    func rounded(roundingMode: NSDecimalNumber.RoundingMode, scale: Int16) -> Decimal {
        let handler = NSDecimalNumberHandler(roundingMode: roundingMode,
                                             scale: scale,
                                             raiseOnExactness: false,
                                             raiseOnOverflow: false,
                                             raiseOnUnderflow: false,
                                             raiseOnDivideByZero: false)
        return (self as NSDecimalNumber).rounding(accordingToBehavior: handler) as Decimal
    }

    /// Return a string description of this number with 2 maximum fraction digits.
    var string: String? {
        return string(maximumFractionDigits: 2)
    }

    /// Returns a string containing the formatted value of the decimal number.
    ///
    /// - Parameters:
    ///   - minimumFractionDigits: Default value is 0.
    ///   - maximumFractionDigits: The maximum number of digits after the decimal separator.
    /// - Returns: A string containing the formatted value of the decimal number.
    func string(minimumFractionDigits: Int = 0, maximumFractionDigits: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        return numberFormatter.string(from: self as NSDecimalNumber)
    }
}
