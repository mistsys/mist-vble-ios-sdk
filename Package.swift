// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MistSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "MistSDK", targets: ["MistSDK", "MistDR"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "MistSDK", path: "Sources/MistSDK.xcframework"),
        .binaryTarget(name: "MistDR", path: "Sources/MistDR.xcframework")
    ],
    swiftLanguageVersions: [.v5]
)
