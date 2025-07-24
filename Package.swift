// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "crossnotes",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .macCatalyst(.v13)],
    dependencies: [
        .package(
            url: "https://github.com/stackotter/swift-cross-ui",
            branch: "main"
        )
    ],
    targets: [
        .executableTarget(
            name: "crossnotes",
            dependencies: [
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
                .product(name: "DefaultBackend", package: "swift-cross-ui")
            ]
        )
    ]
)
