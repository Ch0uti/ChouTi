// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "ChouTi",
  platforms: [
    .macOS(.v10_14), .iOS(.v13), .tvOS(.v13),
  ],
  products: [
    .library(
      name: "ChouTi",
      targets: ["ChouTi"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick", from: "2.2.0"),
    .package(url: "https://github.com/Quick/Nimble", .exact("8.0.2")),
  ],
  targets: [
    .target(
      name: "ChouTi"
    ),
    .testTarget(
      name: "ChouTiTests",
      dependencies: [
        "ChouTi",
        "Quick",
        "Nimble",
      ]
    ),
  ]
)
