// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaygroundForSwiftServer",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(name: "Appwrite", url: "https://github.com/appwrite/sdk-for-swift", .exact("5.0.2")),
    ],
    targets: [
        .executableTarget(
            name: "PlaygroundForSwiftServer",
            dependencies: [
                "Appwrite"
            ],
            resources: [
                .process("Resources/nature.jpg")
            ]
        )
    ]
)
