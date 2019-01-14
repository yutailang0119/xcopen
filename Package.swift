// swift-tools-version:4.2
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
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "4.4.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0"),
        .package(url: "https://github.com/yutailang0119/ProgressSpinnerKit", from: "0.1.0"),
    ],
    targets: [
        .target(name: "xcopen", dependencies: ["XCOpenKit"]),
        .target(name: "XCOpenKit", dependencies: ["PathKit", "RxSwift", "Utility", "ProgressSpinnerKit"]),
        .testTarget(name: "XCOpenKitTests", dependencies: ["XCOpenKit"])
    ]
)
