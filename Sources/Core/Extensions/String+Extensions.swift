// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

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

public extension String {
    /// Returns a new string made by removing whitespaces and newlines from both ends of the receiver.
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Returns a new string made by removing whitespaces from both ends of the receiver.
    func whitespacesTrimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    /// An `NSRange` that represents the full range of the string.
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    /// Returns a substring with the given `NSRange`, or `nil` if the range can't be converted.
    func substring(with nsRange: NSRange) -> String? {
        guard let range = range(from: nsRange) else {
            return nil
        }
        return String(self[range])
    }

    /// Returns a range equivalent to the given `NSRange`, or `nil` if the range can't be converted.
    func range(from nsRange: NSRange) -> Range<Index>? {
        guard nsRange.location >= 0, nsRange.length >= 0 else {
            return nil
        }
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex) else {
            return nil
        }
        return from16..<to16
    }
}

// MARK: - Regex Related

public extension String {
    /// Check if the string is an email address.
    var isEmail: Bool {
        // Ref: https://stackoverflow.com/a/39550723/3164091
        let emailRegex = try! NSRegularExpression(
            pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
                "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
                "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
                "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
                "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
                "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
                "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
            options: [.caseInsensitive]
        )
        return emailRegex.firstMatch(in: self, options: [], range: NSRange(0..<utf16.count)) != nil
    }

    /// Replacing regular expression matches with template string.
    /// Could use `self.replacingOccurrences(of: pattern, with: template, options: .regularExpression)`
    func replacingMatches(
        of pattern: String,
        options: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        with template: String
    ) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(
            in: self,
            options: matchingOptions,
            range: NSRange(0..<utf16.count),
            withTemplate: template
        )
    }

    /// Returns matched strings of a regular expression pattern.
    func matchedStrings(
        of pattern: String,
        options: NSRegularExpression.Options = [],
        matchingOptions _: NSRegularExpression.MatchingOptions = []
    ) -> [String] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            return []
        }

        let matches = regex.matches(in: self, options: [], range: NSRange(0..<utf16.count))
        return matches.compactMap {
            substring(with: $0.range)
        }
    }

    /// Returns captured groups of a regular expression pattern for provided match index.
    func capturedGroups(
        of pattern: String,
        options: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        matchIndex: Int = 0
    ) -> [String] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            return []
        }

        guard let match = regex.matches(
            in: self,
            options: matchingOptions,
            range: NSRange(0..<self.utf16.count)
        ).at(matchIndex) else {
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
        return try replacingMatches(of: whitespacesExceptLastOne.pattern, with: "")
            .replacingMatches(of: whitespacesExtented, with: " ")
            .trimmed()
    }
}
