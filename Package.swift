// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InngageIos",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "InngageIos",
            targets: ["InngageIos"]),
    ],

    targets: [
        .target(
            name: "InngageIos",
            dependencies: [],
            path: "InngageIos"),
        .testTarget(
            name: "InngageIosTests",
            dependencies: ["InngageIos"]),
    ]
)
