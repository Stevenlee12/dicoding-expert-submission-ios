// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCGames",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GCGames",
            targets: ["GCGames"])
    ],
    dependencies: [
        .package(path: "../GCAPI"),
        .package(path: "../GCCommon"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from: "5.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GCGames",
            dependencies: [
                "GCAPI",
                "GCCommon",
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "GCGamesTests",
            dependencies: ["GCGames"]
        )
    ]
)
