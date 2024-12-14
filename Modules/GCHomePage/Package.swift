// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCHomePage",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GCHomePage",
            targets: ["GCHomePage"])
    ],
    dependencies: [
        .package(name: "GCCommon", path: "../GCCommon"),
        .package(name: "GCGames", path: "../GCGames"),
        .package(name: "GCDetailGamePage", path: "../GCDetailGamePage"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GCHomePage",
            dependencies: [
              "GCCommon",
              "GCGames",
              "GCDetailGamePage",
              .product(name: "SnapKit", package: "SnapKit")
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "GCHomePageTests",
            dependencies: ["GCHomePage"]
        )
    ]
)
