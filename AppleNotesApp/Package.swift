// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppleNotesApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "AppleNotesApp", targets: ["AppleNotesApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "AppleNotesApp",
            dependencies: [],
            path: "Sources/AppleNotesApp",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
