// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCDetailGamePage",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GCDetailGamePage",
            targets: ["GCDetailGamePage"])
    ],
    dependencies: [
        .package(name: "GCCommon", path: "../GCCommon"),
        .package(name: "GCDetailGame", path: "../GCDetailGame"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GCDetailGamePage",
            dependencies: [
              "GCCommon",
              "GCDetailGame",
              .product(name: "SnapKit", package: "SnapKit")
            ]),
        .testTarget(
            name: "GCDetailGamePageTests",
            dependencies: ["GCDetailGamePage"]
        )
    ]
)
