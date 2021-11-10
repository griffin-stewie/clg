// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clg",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0"),
        .package(url: "https://github.com/mxcl/Path.swift.git", from: "1.0.1"),
        .package(url: "https://github.com/griffin-stewie/ASE", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "clg",
            dependencies: [
                "Core",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
                "ASE",
        ]),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
                "ASE",
        ]),
        .testTarget(
            name: "clgTests",
            dependencies: [
                "clg"
        ]),
        .testTarget(
            name: "CoreTests",
            dependencies: [
                "Core"
        ]),
    ]
)
