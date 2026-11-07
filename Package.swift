// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "KeyCoderHelpers",
    products: [
        .library(name: "KeyCoderHelpers", targets: ["KeyCoderHelpers"]),
    ],
    targets: [
        .target(name: "KeyCoderHelpers"),
        .testTarget(name: "KeyCoderHelpersTests", dependencies: ["KeyCoderHelpers"])
    ]
)
