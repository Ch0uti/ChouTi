// swift-tools-version:4.2

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
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.37.2"),
    .package(url: "https://github.com/Quick/Quick", from: "1.3.2"),
    .package(url: "https://github.com/Quick/Nimble", from: "7.3.1"),
  ],
  targets: [
    .target(
      name: "ChouTi",
      path: "ChouTi/Sources",
      exclude: [
        "ChouTi.h",
        "ChouTi.modulemap",
        "CodeSnippets",
        "Info.plist",
        "iOS",
        "Platform.swift",
      ]
    ),
    .testTarget(
      name: "ChouTiTests",
      dependencies: [
        "ChouTi",
        "Quick",
        "Nimble",
      ],
      path: "ChouTi/Tests",
      exclude: [
        "ChouTiTests/iOS",
      ]
    ),
  ]
)
