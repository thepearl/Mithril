// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mithril",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "Mithril",
            targets: ["Mithril"]
        ),
    ],
    dependencies: [
        // No external dependencies for now - keeping it lightweight
    ],
    targets: [
        .target(
            name: "Mithril",
            dependencies: [],
            path: "Sources/Mithril"
        ),
        .testTarget(
            name: "MithrilTests",
            dependencies: ["Mithril"],
            path: "Tests/MithrilTests"
        ),
    ]
)