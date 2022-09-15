// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaygroundForSwiftServer",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Appwrite", url: "https://github.com/appwrite/sdk-for-swift", .exact("1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
