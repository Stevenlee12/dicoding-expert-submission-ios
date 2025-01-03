// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCDetailGame",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GCDetailGame",
            targets: ["GCDetailGame"])
    ],
    dependencies: [
        .package(path: "../GCCommon"),
        .package(url: "https://github.com/Stevenlee12/Modularization-API-Package.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from: "5.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GCDetailGame",
            dependencies: [
                "GCCommon",
                .product(name: "Modularization-API-Package", package: "Modularization-API-Package"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "GCDetailGameTests",
            dependencies: ["GCDetailGame"]
        )
    ]
)
