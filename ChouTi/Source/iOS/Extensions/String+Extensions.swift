//
//  Created by Honghao Zhang on 09/24/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

public extension String {
    /// Returns a new string made by removing whitespaces and newlines from both ends of the receiver.
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Returns a new string made by removing whitespaces from both ends of the receiver.
    func whitespacesTrimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

public extension String {
    /// An `NSRange` that represents the full range of the string.
    var fullNsrange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    private func utf16Range(from nsrange: NSRange) -> Range<UTF16View.Index>? {
        guard let range = Range(nsrange) else {
            return nil
        }

        let utf16Start = UTF16Index(encodedOffset: range.lowerBound)
        let utf16End = UTF16Index(encodedOffset: range.upperBound)
        guard (utf16Start <= utf16End) &&
            (utf16.startIndex <= utf16Start && utf16Start <= utf16.endIndex) &&
            (utf16.startIndex <= utf16End && utf16End <= utf16.endIndex) else {
                return nil
        }

        return utf16Start..<utf16End
    }

    /// Returns a substring with the given `NSRange`, or `nil` if the range can't be converted.
    func substring(with nsrange: NSRange) -> String? {
        guard let utf16Range = utf16Range(from: nsrange) else {
            return nil
        }
        return String(utf16[utf16Range])
    }

    /// Returns a range equivalent to the given `NSRange`, or `nil` if the range can't be converted.
    func range(from nsrange: NSRange) -> Range<Index>? {
        guard let utf16Range = utf16Range(from: nsrange) else {
            return nil
        }

        guard let start = Index(utf16Range.lowerBound, within: self),
            let end = Index(utf16Range.upperBound, within: self) else {
                return nil
        }

        return start..<end
    }
}

// MARK: - Regex Related
public extension String {

    /// Check if the string is an email address.
    var isEmail: Bool {
        let emailRegex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
                                                  options: [.caseInsensitive])
        return emailRegex.firstMatch(in: self, options: [], range: NSRange(0..<self.utf16.count)) != nil
    }

    /// Replacing regular expression matches with template string.
    /// Could use `self.replacingOccurrences(of: pattern, with: template, options: .regularExpression)`
    func replacingMatches(of pattern: String,
                          options: NSRegularExpression.Options = [],
                          matchingOptions: NSRegularExpression.MatchingOptions = [],
                          with template: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self,
                                              options: matchingOptions,
                                              range: NSRange(0..<self.utf16.count),
                                              withTemplate: template)
    }

    /// Returns matched strings of a regular expression pattern.
    func matchedStrings(of pattern: String,
                        options: NSRegularExpression.Options = [],
                        matchingOptions: NSRegularExpression.MatchingOptions = []) -> [String] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            return []
        }

        let matches = regex.matches(in: self, options: [], range: NSRange(0..<self.utf16.count))
        return matches.compactMap {
            substring(with: $0.range)
        }
    }

    /// Returns captured groups of a regular expression pattern for provided match index.
    func capturedGroups(of pattern: String,
                        options: NSRegularExpression.Options = [],
                        matchingOptions: NSRegularExpression.MatchingOptions = [],
                        matchIndex: Int = 0) -> [String] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            return []
        }

        guard let match = regex.matches(in: self,
                                        options: matchingOptions,
                                        range: NSRange(0..<self.utf16.count)).at(matchIndex) else {
            return []
        }

        return (1..<match.numberOfRanges).compactMap {
            substring(with: match.range(at: $0))
        }
    }

    /// Returns percentage strings.
    func percentageStrings() -> [String] {
        return matchedStrings(of: RegularExpressionPattern.percentage)
    }

    /// Returns a new string by removing leading and trailing white-space from a string, replacing sequences of whitespace characters by a single space, and returns the resulting string.
    func whitespacesNormalized() throws -> String {
        let whitespacesExceptLastOne = NSRegularExpression.whitespacesExceptLastOne()
        let whitespacesExtented = RegularExpressionPattern.whitespacesExtented
        return try self.replacingMatches(of: whitespacesExceptLastOne.pattern, with: "")
            .replacingMatches(of: whitespacesExtented, with: " ")
            .trimmed()
    }
}

// MARK: - Regular Expression Patterns
public extension String {
    enum RegularExpressionPattern {
        /// Matching one or more tabs.
        static var tabs: String {
            return "\\t+"
        }

        /// Matching one or more newlines.
        static var newlines: String {
            return "[\\r|\\n]+"
        }

        /// Matching one or more white spaces.
        static var whitespaces: String {
            return "\\s+"
        }

        /// Matching one or more white spaces, tabs and newlines
        static var whitespacesExtented: String {
            return "[\\s|\\t|\\r|\\n]+"
        }

        /// Matching percentage strings like: 25%, .1%.
        static var percentage: String {
            return "\\d*\\.?\\d+?%"
        }
    }
}
