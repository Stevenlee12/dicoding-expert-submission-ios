// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCProfilePage",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GCProfilePage",
            targets: ["GCProfilePage"])
    ],
    dependencies: [
        .package(name: "GCCommon", path: "../GCCommon"),
        .package(name: "GCProfile", path: "../GCProfile")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GCProfilePage",
            dependencies: [
              "GCCommon",
              "GCProfile"
            ]),
        .testTarget(
            name: "GCProfilePageTests",
            dependencies: ["GCProfilePage"]
        )
    ]
)
