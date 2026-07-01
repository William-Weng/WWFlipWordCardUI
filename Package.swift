// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWFlipWordCardUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "WWFlipWordCardUI", targets: ["WWFlipWordCardUI"]),
    ],
    targets: [
        .target(name: "WWFlipWordCardUI", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
