// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "ChouTi",
  products: [
    .library(
      name: "ChouTi",
      targets: ["ChouTi"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick", from: "2.2.0"),
    .package(url: "https://github.com/Quick/Nimble", from: "8.0.0"),
  ],
  targets: [
    .target(
      name: "ChouTi",
      path: "Sources"
    ),
    .testTarget(
      name: "ChouTiTests",
      dependencies: [
        "ChouTi",
        "Quick",
        "Nimble",
      ],
      path: "Tests"
    ),
  ]
)
