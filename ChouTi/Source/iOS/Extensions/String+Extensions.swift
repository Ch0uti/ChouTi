//
//  String+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-24.
//
//

import Foundation

public extension String {

    /**
     Return whitespace and newline trimmed string.
     
     - returns: whitespace and newline trimmed string
     */
    func trimmed() -> String {
        return self.whitespaceAndNewlineTrimmed()
    }

    /**
     Return whitespace and newline trimmed string.
     
     - returns: whitespace and newline trimmed string
     */
    func whitespaceAndNewlineTrimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /**
     Return whitespace trimmed string.
     
     - returns: whitespace trimmed string
     */
    func whitespaceTrimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

// MARK: - Regex Related
public extension String {

    func isEmail() -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
        return emailRegex.firstMatch(in: self, options: [], range: self.fullNSRange()) != nil
    }

    func replaceRegex(_ regex: NSRegularExpression, withString template: String) -> String {
        return regex.stringByReplacingMatches(in: self, options: [], range: self.fullNSRange(), withTemplate: template)
    }

    func matchedStringForRegex(_ regex: NSRegularExpression) -> [String] {
        var matchedStrings = [String]()

        let matches = regex.matches(in: self, options: [], range: self.fullNSRange())
        for match in matches {
            if let range = rangeFromNSRange(match.range) {
                let newMatchedString = String(self[range.lowerBound..<range.upperBound])
                matchedStrings.append(newMatchedString)
            }
        }

        return matchedStrings
    }

    func firstMatchStringForRegex(_ regex: NSRegularExpression) -> String? {
        let matchResult = regex.firstMatch(in: self, options: [], range: self.fullNSRange())
        if let nsRange = matchResult?.range, let range = rangeFromNSRange(nsRange) {
            return String(self[range.lowerBound..<range.upperBound])
        }

        return nil
    }

    func fullNSRange() -> NSRange {
        return NSRange(location: 0, length: self.distance(from: self.startIndex, to: self.endIndex))
    }

    func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        let from = self.index(self.startIndex, offsetBy: nsRange.location, limitedBy: self.endIndex)
        let to = self.index(from!, offsetBy: nsRange.length, limitedBy: self.endIndex)
        return from! ..< to!
    }

    /**
     Strips leading and trailing white-space from a string, replaces sequences of whitespace characters by a single space, and returns the resulting string.
     
     - returns: Normalized string
     */
    func normalizeSpaces() -> String {
        let whiteSpacesExceptLastOne = NSRegularExpression.whiteSpacesExceptLastOne()
        let tabNewlineSpaceRegex = NSRegularExpression.tabNewlineSpaceRegex()
        return self.replaceRegex(whiteSpacesExceptLastOne, withString: "").replaceRegex(tabNewlineSpaceRegex, withString: " ").trimmed()
    }

    func removeTabsAndReplaceNewlineWithEmptySpace() -> String {
        let tabRegex = NSRegularExpression.tabRegex()
        let newLineRegex = NSRegularExpression.newlineRegex()
        let whiteSpaceRegex = NSRegularExpression.whiteSpaceRegex()

        return self.replaceRegex(tabRegex, withString: "").replaceRegex(newLineRegex, withString: " ").replaceRegex(whiteSpaceRegex, withString: " ")
    }

    func percentNumberString() -> String? {
        let percentRegex = NSRegularExpression.percentNumberRegex()
        return firstMatchStringForRegex(percentRegex)
    }
}
