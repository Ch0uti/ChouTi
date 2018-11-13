//
//  Created by Honghao Zhang on 10/30/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class String_ExtensionsTest: XCTestCase {
    func testTrimmed() {
        XCTAssertEqual("123".trimmed(), "123")
        XCTAssertEqual("123 ".trimmed(), "123")
        XCTAssertEqual("  123 ".trimmed(), "123")
        XCTAssertEqual("""
                       123
                       abd
                       """.trimmed(),
                       """
                       123
                       abd
                       """)
        XCTAssertEqual("\n 123".trimmed(), "123")
        XCTAssertEqual("123 \n".trimmed(), "123")
        XCTAssertEqual("\n123\n".trimmed(), "123")
    }

    func testWhitespaceSTrimmed() {
        XCTAssertEqual("123".whitespacesTrimmed(), "123")
        XCTAssertEqual("123 ".whitespacesTrimmed(), "123")
        XCTAssertEqual(" 123 ".whitespacesTrimmed(), "123")
        XCTAssertEqual("\n 123 ".whitespacesTrimmed(), "\n 123")
        XCTAssertEqual("123 \n".whitespacesTrimmed(), "123 \n")
        XCTAssertEqual("123\n ".whitespacesTrimmed(), "123\n")
    }

    func testFullNsrange() {
        let nsrange_0 = "".fullNsrange
        XCTAssertEqual(nsrange_0.location, 0)
        XCTAssertEqual(nsrange_0.length, 0)

        let nsrange = "123456abc".fullNsrange
        XCTAssertEqual(nsrange.location, 0)
        XCTAssertEqual(nsrange.length, 9)

        let nsrangeEmoji = "123456🤪abc".fullNsrange
        XCTAssertEqual(nsrangeEmoji.location, 0)
        XCTAssertEqual(nsrangeEmoji.length, 11)
    }

    func testSubstringWithNsrange() {
        let nsrange_1_0 = NSRange(location: -1, length: 0)
        XCTAssertEqual("123abc".substring(with: nsrange_1_0), nil)

        let nsrange0_0 = NSRange(location: 0, length: 0)
        XCTAssertEqual("123abc".substring(with: nsrange0_0), "")
        XCTAssertEqual("".substring(with: nsrange0_0), "")

        let nsrange0__1 = NSRange(location: 0, length: -1)
        XCTAssertEqual("123abc".substring(with: nsrange0__1), nil)
        XCTAssertEqual("".substring(with: nsrange0__1), nil)

        let nsrange2_0 = NSRange(location: 2, length: 0)
        XCTAssertEqual("123abc".substring(with: nsrange2_0), "")

        let nsrange2__1 = NSRange(location: 2, length: -1)
        XCTAssertEqual("123abc".substring(with: nsrange2__1), nil)

        let nsrange1_3 = NSRange(location: 1, length: 3)
        XCTAssertEqual("123abc".substring(with: nsrange1_3), "23a")
        XCTAssertEqual("1🤪23abc".substring(with: nsrange1_3), "🤪2")

        XCTAssertEqual("".substring(with: nsrange1_3), nil)
        XCTAssertEqual("1".substring(with: nsrange1_3), nil)
        XCTAssertEqual("12".substring(with: nsrange1_3), nil)
    }

    func testRangeFromNsrange() {
        let string = "123abc"
        XCTAssertEqual(string.range(from: NSRange(location: -1, length: -1)), nil)
        XCTAssertEqual(string.range(from: NSRange(location: -1, length: 0)), nil)
        XCTAssertEqual(string.range(from: NSRange(location: -1, length: 2)), nil)

        XCTAssertEqual(string.range(from: NSRange(location: 0, length: -1)), nil)
        let range0_0 = string.range(from: NSRange(location: 0, length: 0))
        if let range0_0 = range0_0 {
            XCTAssertEqual(string[range0_0], "")
        } else {
            XCTFail("nil range")
        }

        let range0_1 = string.range(from: NSRange(location: 0, length: 1))
        if let range0_1 = range0_1 {
            XCTAssertEqual(string[range0_1], "1")
        } else {
            XCTFail("nil range")
        }

        XCTAssertEqual(string.range(from: NSRange(location: 0, length: 7)), nil)

        let range6_0 = string.range(from: NSRange(location: 6, length: 0))
        if let range6_0 = range6_0 {
            XCTAssertEqual(string[range6_0], "")
        } else {
            XCTFail("nil range")
        }

        XCTAssertEqual(string.range(from: NSRange(location: 7, length: 1)), nil)

        let emojiString = "1😃23abc"
        let rangeEmoji0_3 = string.range(from: NSRange(location: 0, length: 3))
        if let rangeEmoji0_3 = rangeEmoji0_3 {
            XCTAssertEqual(emojiString[rangeEmoji0_3], "1😃")
        } else {
            XCTFail("nil range")
        }
    }

    func testIsEmail() {
        XCTAssertTrue("foo.bar1@gmail.com".isEmail)
        XCTAssertTrue("foo+bar2@gmail.com".isEmail)
        XCTAssertTrue("foo-123@gmail.com".isEmail)
        XCTAssertTrue("foo_123@gmail.com".isEmail)
        XCTAssertTrue("123@gmail.co".isEmail)
        XCTAssertTrue("123@123.gmail.com".isEmail)
        XCTAssertTrue("ad#asd@gmail.com".isEmail)
        XCTAssertTrue("ad*@gmail.com".isEmail)
        XCTAssertFalse(".@gmail.com".isEmail)
        XCTAssertFalse("ad.@gmail.com".isEmail)
        XCTAssertFalse("ad@@gmail.com".isEmail)
        XCTAssertFalse("ad,@gmail.com".isEmail)
        XCTAssertFalse("foo@gmail..com".isEmail)
        XCTAssertFalse("foo@.gmail..com".isEmail)
        XCTAssertFalse("foo@.gmail*com".isEmail)
        XCTAssertFalse("foo@.gmail-com".isEmail)
    }

    func testReplacingMatches() {
        XCTAssertEqual(try? "foo123bar".replacingMatches(of: "([a-z]+)(\\d+)([a-z]+)", with: "($1)-($2)-($3)"),
                       "(foo)-(123)-(bar)")

        XCTAssertEqual(try? "foo123bar".replacingMatches(of: "(\\d)", with: "($1)"),
                       "foo(1)(2)(3)bar")
        XCTAssertEqual(try? "foo123bar".replacingMatches(of: "(\\d)(\\d)", with: "($1)-($2)"),
                       "foo(1)-(2)3bar")
        // The next matche starts from end of last match
        XCTAssertEqual(try? "foo1234bar".replacingMatches(of: "(\\d)(\\d)", with: "($1)-($2)"),
                       "foo(1)-(2)(3)-(4)bar")

        XCTAssertEqual(try? "foo1234bar".replacingMatches(of: "(\\d)(\\d)", with: "($0)"),
                       "foo(12)(34)bar")
        XCTAssertEqual(try? "foo1234bar".replacingMatches(of: "(\\d)(\\d)", with: "($0)-($1)"),
                       "foo(12)-(1)(34)-(3)bar")

        XCTAssertEqual(try? "foo1234bar".replacingMatches(of: "(\\d{2})", with: "($0)"),
                       "foo(12)(34)bar")
        XCTAssertEqual(try? "foo1234bar".replacingMatches(of: "(\\d{2})", with: "($1)"),
                       "foo(12)(34)bar")

        // Ref: https://stackoverflow.com/a/38907873/3164091
        let emojiCharacters = "\\U0001F600-\\U0001F64F\\U0001F300-\\U0001F5FF\\U0001F680-\\U0001F6FF\\u2600-\\u26FF"
        XCTAssertEqual(try? "foo123😀bar".replacingMatches(of: "(\\w+)([\(emojiCharacters)]+)([a-z]+)", with: "($1)-($2)-($3)"),
                       "(foo123)-(😀)-(bar)")
    }

    func testMatchedStrings() {
        XCTAssertEqual("123foo".matchedStrings(of: "??"), [])
        XCTAssertEqual("123foo".matchedStrings(of: "(\\d+)"), ["123"])
        XCTAssertEqual("123foo".matchedStrings(of: "([a-z]+)"), ["foo"])
        XCTAssertEqual("123foo".matchedStrings(of: "(\\d)([a-z])"), ["3f"])
        XCTAssertEqual("foo123bar".matchedStrings(of: "([a-z]+)(\\d+)([a-z]+)"), ["foo123bar"])
        XCTAssertEqual("foo123bar".matchedStrings(of: "(([a-z]+)(\\d+))([a-z]+)"), ["foo123bar"])
        XCTAssertEqual("123foo".matchedStrings(of: "(\\d)"), ["1", "2", "3"])
        XCTAssertEqual("123foo".matchedStrings(of: "(\\d)(\\d)"), ["12"])
        XCTAssertEqual("1234foo".matchedStrings(of: "(\\d)(\\d)"), ["12", "34"])
        XCTAssertEqual("123foo45".matchedStrings(of: "(\\d)(\\d)"), ["12", "45"])
    }

    func testCapturedGroups() {
        XCTAssertEqual("123foo".capturedGroups(of: "??"), [])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d+)"), ["123"])
        XCTAssertEqual("123foo".capturedGroups(of: "([a-z]+)"), ["foo"])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)([a-z])"), ["3", "f"])
        XCTAssertEqual("foo123bar".capturedGroups(of: "([a-z]+)(\\d+)([a-z]+)"), ["foo", "123", "bar"])
        XCTAssertEqual("foo123bar".capturedGroups(of: "(([a-z]+)(\\d+))([a-z]+)"), ["foo123", "foo", "123", "bar"])
        XCTAssertEqual("foo".capturedGroups(of: "(\\d)"), [])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)"), ["1"])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)", matchIndex: 1), ["2"])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)", matchIndex: 2), ["3"])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)", matchIndex: 3), [])
        XCTAssertEqual("123foo".capturedGroups(of: "(\\d)(\\d)"), ["1", "2"])
    }

    func testPercentageStrings() {
        XCTAssertEqual("123foo".percentageStrings(), [])
        XCTAssertEqual("123foo12%".percentageStrings(), ["12%"])
        XCTAssertEqual("123foo12%abd1%".percentageStrings(), ["12%", "1%"])
        XCTAssertEqual("123foo12%abd1%.01%".percentageStrings(), ["12%", "1%", ".01%"])
        XCTAssertEqual("123foo12%abd1%12..11%".percentageStrings(), ["12%", "1%", ".11%"])
        XCTAssertEqual("123foo.1%".percentageStrings(), [".1%"])
        XCTAssertEqual("123fo.001%%".percentageStrings(), [".001%"])
        XCTAssertEqual("123fo2.1%%".percentageStrings(), ["2.1%"])
        XCTAssertEqual("123fo1230%%".percentageStrings(), ["1230%"])
        XCTAssertEqual("123fo123.0001%%".percentageStrings(), ["123.0001%"])
        XCTAssertEqual("123fo123.00.01%%".percentageStrings(), ["00.01%"])
        XCTAssertEqual("123fo123...01%%".percentageStrings(), [".01%"])
    }

    func testWhitespacesNormalized() {
        XCTAssertEqual(try? "123 foo".whitespacesNormalized(), "123 foo")
        XCTAssertEqual(try? "123  foo".whitespacesNormalized(), "123 foo")
        XCTAssertEqual(try? " 123     foo".whitespacesNormalized(), "123 foo")
        XCTAssertEqual(try? " 123     foo    ".whitespacesNormalized(), "123 foo")
        XCTAssertEqual(try?
            """
             123 foo
            """.whitespacesNormalized(), "123 foo")
        XCTAssertEqual(try?
            """
                123     foo

            """.whitespacesNormalized(), "123 foo")
    }

}
