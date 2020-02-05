// Copyright © 2020 ChouTi. All rights reserved.

import Foundation
import Nimble
import Quick
@testable import ChouTi

class Decimal_ExtensionsTests: QuickSpec {
  override func spec() {
    roundedSpec()
    stringSpec()
  }
}

extension Decimal_ExtensionsTests {
  func roundedSpec() {
    it("should get a rounded decimal number.") {
      expect(Decimal(1.2).rounded) == Decimal(string: "1.2")!
      expect(Decimal(0.2).rounded) == Decimal(string: "0.2")!
      expect(Decimal(0.23).rounded) == Decimal(string: "0.23")!
      expect(Decimal(0.234).rounded) == Decimal(string: "0.23")!
      expect(Decimal(0.235).rounded) == Decimal(string: "0.23")! // Why? Expect to be 0.24
      expect(Decimal(0.2351).rounded) == Decimal(string: "0.24")! // Why?
      expect(Decimal(0.244).rounded) == Decimal(string: "0.24")!
      expect(Decimal(0.245).rounded) == Decimal(string: "0.25")!
      expect(Decimal(-1.245).rounded) == Decimal(string: "-1.25")!
      expect(Decimal(-1.244).rounded) == Decimal(string: "-1.24")!

      expect(Decimal(1.25).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "1.3")!
      expect(Decimal(1.24).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "1.2")!
      expect(Decimal(0.25).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "0.3")!
      expect(Decimal(0.24).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "0.2")!
      expect(Decimal(1.35).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "1.4")!
      expect(Decimal(1.34).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "1.3")!
      expect(Decimal(0.35).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "0.4")!
      expect(Decimal(0.34).rounded(roundingMode: .plain, scale: 1)) == Decimal(string: "0.3")!

      expect(Decimal(1.25).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "1.2")!
      expect(Decimal(1.24).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "1.2")!
      expect(Decimal(0.25).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "0.2")!
      expect(Decimal(0.24).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "0.2")!
      expect(Decimal(1.35).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "1.4")!
      expect(Decimal(1.34).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "1.3")!
      expect(Decimal(0.35).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "0.4")!
      expect(Decimal(0.34).rounded(roundingMode: .bankers, scale: 1)) == Decimal(string: "0.3")!
    }
  }

  func stringSpec() {
    it("should get a decimal string.") {
      expect(Decimal(1.2).string) == "1.2"
      expect(Decimal(0.2).string) == "0.2"
      expect(Decimal(0.23).string) == "0.23"
      expect(Decimal(0.234).string) == "0.23"
      expect(Decimal(0.235).string) == "0.23"
      expect(Decimal(0.245).string) == "0.24"

      expect(Decimal(0.234).string(maximumFractionDigits: -1)) == "0.234"
      expect(Decimal(0.234).string(maximumFractionDigits: 0)) == "0"
      expect(Decimal(0.234).string(maximumFractionDigits: 1)) == "0.2"
      expect(Decimal(0.234).string(maximumFractionDigits: 2)) == "0.23"
      expect(Decimal(0.234).string(maximumFractionDigits: 3)) == "0.234"
      expect(Decimal(0.234).string(maximumFractionDigits: 4)) == "0.234"

      expect(Decimal(0.234).string(minimumFractionDigits: 0, maximumFractionDigits: 0)) == "0"
      expect(Decimal(0.234).string(minimumFractionDigits: 1, maximumFractionDigits: 0)) == "0"
      expect(Decimal(0.234).string(minimumFractionDigits: 1, maximumFractionDigits: 5)) == "0.234"
      expect(Decimal(0.234).string(minimumFractionDigits: 4, maximumFractionDigits: 5)) == "0.2340"
    }
  }
}
