// Copyright © 2020 ChouTi. All rights reserved.

import Foundation
import Nimble
import Quick
@testable import ChouTi

class Codable_ExtensionsTests: QuickSpec {
  override func spec() {
    struct Model: Codable {
      let number: Decimal
    }
    let jsonString =
      """
      {"number":"123.456"}
      """
    context("decoding") {
      it("should get correct decimal number") {
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)!
        let decoded = try! decoder.decode(Model.self, from: data)
        expect(decoded.number) == Decimal(string: "123.456")!
      }

      it("should get error") {
        let badJsonString =
          """
          {"number":"foo"}
          """

        let decoder = JSONDecoder()
        let data = badJsonString.data(using: .utf8)!
        do {
          _ = try decoder.decode(Model.self, from: data)
        } catch {
          expect(error is DecodingError) == true
        }
      }
    }

    context("encoding") {
      it("should get correct json string") {
        let encoder = JSONEncoder()
        let model = Model(number: Decimal(string: "123.456")!)
        let encoded = try! encoder.encode(model).string(encoding: .utf8)
        expect(encoded) == jsonString
      }
    }
  }
}
