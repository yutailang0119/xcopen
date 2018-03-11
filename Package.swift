// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCOpen",
    products: [
        .executable(name: "xcopen", targets: ["xcopen"]),
        .library(name: "XCOpenKit", targets: ["XCOpenKit"]),
    ], 
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
    ],
    targets: [
        .target(name: "xcopen", dependencies: ["XCOpenKit"]),
        .target(name: "XCOpenKit", dependencies: ["PathKit"]),
        .testTarget(name: "XCOpenKitTests", dependencies: ["XCOpenKit"])
    ]
)
