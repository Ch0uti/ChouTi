// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "ChouTi",
  products: [
    .librart(
      name: "ChouTi",
      targets: ["ChouTi"]
    ),
  ],
  targets: [
    .target(
      name: "ChouTi",
      path: "Chouti/Sources"
    ),
    .testTarget(
      name: "ChouTiTests",
      dependencies: ["ChouTi"]
    )
  ]
)
