// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clg",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .revision("12941604a7cd6c31555b014ce3f5f8348a51564a")),
        .package(url: "https://github.com/mxcl/Path.swift.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "clg",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
            ]),
        .testTarget(
            name: "clgTests",
            dependencies: ["clg"]),
    ]
)
