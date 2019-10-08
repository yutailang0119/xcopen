// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCOpen",
    products: [
        .executable(name: "xcopen", targets: ["xcopen"]),
        .library(name: "XCOpenKit", targets: ["XCOpenKit"]),
    ], 
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "4.4.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
        .package(url: "https://github.com/yutailang0119/ProgressSpinnerKit", from: "0.3.0"),
    ],
    targets: [
        .target(name: "xcopen", dependencies: ["XCOpenKit"]),
        .target(name: "XCOpenKit", dependencies: ["PathKit", "RxSwift", "SPMUtility", "ProgressSpinnerKit"]),
        .testTarget(name: "XCOpenKitTests", dependencies: ["XCOpenKit"])
    ]
)
