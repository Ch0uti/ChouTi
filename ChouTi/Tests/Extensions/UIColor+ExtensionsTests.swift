//
//  UIColor+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2016-01-28.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

class UIColor_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("color component") {
            it("should get right color components") {
                let red: CGFloat = 0.12
                let green: CGFloat = 0.23
                let blue: CGFloat = 0.34
                let alpha: CGFloat = 0.45
                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

                expect(color.redComponent()) == red
                expect(color.greenComponent()) == green
                expect(color.blueComponent()) == blue
                expect(color.alphaComponent()) == alpha

                expect(color.getRGBAComponents().red) == red
                expect(color.getRGBAComponents().green) == green
                expect(color.getRGBAComponents().blue) == blue
                expect(color.getRGBAComponents().alpha) == alpha
            }
        }

        describe("random color") {
            it("should get a random color and they are differnet") {
                let color1 = UIColor.random()
                expect(color1).toNot(beNil())
                let color2 = UIColor.random()
                expect(color2).toNot(beNil())

                expect(color1.redComponent() != color2.redComponent()
                    || color1.greenComponent() != color2.greenComponent()
                    || color1.blueComponent() != color2.blueComponent()
                    || color1.alphaComponent() != color2.alphaComponent()) == true
            }

            it("should get random color that respects random alpha") {
                let nonAlphaColor = UIColor.random(randomAlpha: false)
                expect(nonAlphaColor.alphaComponent()) == 1.0

                let alphaColor = UIColor.random(randomAlpha: true)
                expect(alphaColor.alphaComponent()) <= 1.0
            }
        }

        describe("color mutation") {
            it("should get a color between two colors") {
                let minColor = UIColor.random()
                let maxColor = UIColor.random()
                let percent: CGFloat = 0.3
                let colorInBetween = UIColor.colorBetweenMinColor(minColor, maxColor: maxColor, percent: 0.3)

                expect(colorInBetween.redComponent()) ==
                    minColor.redComponent() + (maxColor.redComponent() - minColor.redComponent()) * percent
                expect(colorInBetween.greenComponent()) ==
                    minColor.greenComponent() + (maxColor.greenComponent() - minColor.greenComponent()) * percent
                expect(colorInBetween.blueComponent()) ==
                    minColor.blueComponent() + (maxColor.blueComponent() - minColor.blueComponent()) * percent
                expect(colorInBetween.alphaComponent()) ==
                    minColor.alphaComponent() + (maxColor.alphaComponent() - minColor.alphaComponent()) * percent
            }

            it("should get a darker color") {
                let color = UIColor.red
                let darkerColor = color.darkerColor(brightnessDecreaseFactor: 0.5)
                var brightness: CGFloat = -1.0
                darkerColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
                expect(brightness) == 0.5
            }

            it("should get a ligher color") {
                let color = UIColor.blue
                let lighterColor = color.lighterColor(brightnessIncreaseFactor: 1.4)
                var brightness: CGFloat = -1.0
                lighterColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
                expect(brightness) == 1.4
            }
        }

        describe("hex color") {
            describe("init with three digits") {
                it("should get the correct color") {
                    let color = UIColor(hex3: 0x123)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x11 / 255
                    expect(g) == 0x22 / 255
                    expect(b) == 0x33 / 255
                    expect(a) == 1
                }

                it("should get the correct color with the provide alpha") {
                    let color = UIColor(hex3: 0x123, alpha: 0.5)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x11 / 255
                    expect(g) == 0x22 / 255
                    expect(b) == 0x33 / 255
                    expect(a) == (0xFF / 2) / 255
                }
            }

            describe("init with four digits") {
                it("should get the correct color") {
                    let color = UIColor(hex4: 0x1234)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x11 / 255
                    expect(g) == 0x22 / 255
                    expect(b) == 0x33 / 255
                    expect(a) == 0x44 / 255
                }
            }

            describe("init with six digits") {
                it("should get the correct color") {
                    let color = UIColor(hex6: 0x123456)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x12 / 255
                    expect(g) == 0x34 / 255
                    expect(b) == 0x56 / 255
                    expect(a) == 1
                }

                it("should get the correct color with the provide alpha") {
                    let color = UIColor(hex6: 0x123456, alpha: 0.5)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x12 / 255
                    expect(g) == 0x34 / 255
                    expect(b) == 0x56 / 255
                    expect(a) == (0xFF / 2) / 255
                }
            }

            describe("init with eight digits") {
                it("should get the correct color") {
                    let color = UIColor(hex8: 0x12345678)
                    let (r, g, b, a) = color.getRGBAComponents()
                    expect(r) == 0x12 / 255
                    expect(g) == 0x34 / 255
                    expect(b) == 0x56 / 255
                    expect(a) == 0x78 / 255
                }
            }

            describe("init with string") {
                it("should get the correct color with #RGB format") {
                    let color = UIColor(hexString: "#123")
                    expect(color).toNot(beNil())
                    let (r, g, b, a) = color!.getRGBAComponents()
                    expect(r) == 0x11 / 255
                    expect(g) == 0x22 / 255
                    expect(b) == 0x33 / 255
                    expect(a) == 1
                }

                it("should get the correct color with #RGBA format") {
                    let color = UIColor(hexString: "#1234")
                    expect(color).toNot(beNil())
                    let (r, g, b, a) = color!.getRGBAComponents()
                    expect(r) == 0x11 / 255
                    expect(g) == 0x22 / 255
                    expect(b) == 0x33 / 255
                    expect(a) == 0x44 / 255
                }

                it("should get the correct color with #RRGGBB format") {
                    let color = UIColor(hexString: "#123456")
                    expect(color).toNot(beNil())
                    let (r, g, b, a) = color!.getRGBAComponents()
                    expect(r) == 0x12 / 255
                    expect(g) == 0x34 / 255
                    expect(b) == 0x56 / 255
                    expect(a) == 1
                }

                it("should get the correct color with #RRGGBBAA format") {
                    let color = UIColor(hexString: "#12345678")
                    expect(color).toNot(beNil())
                    let (r, g, b, a) = color!.getRGBAComponents()
                    expect(r) == 0x12 / 255
                    expect(g) == 0x34 / 255
                    expect(b) == 0x56 / 255
                    expect(a) == 0x78 / 255
                }
            }

            describe("get hex string") {
                it("should get the correct hex string") {
                    let color = UIColor(red: 0x12 / 255, green: 0x34 / 255, blue: 0x56 / 255, alpha: 0x78 / 255)
                    expect(color.hexString(includeAlpha: false)) == "#123456"
                }

                it("should get the correct hex string with alpha") {
                    let color = UIColor(red: 0x12 / 255, green: 0x34 / 255, blue: 0x56 / 255, alpha: 0x78 / 255)
                    expect(color.hexString()) == "#12345678"
                    expect(color.hexString(includeAlpha: true)) == "#12345678"
                }
            }
        }
    }
}
