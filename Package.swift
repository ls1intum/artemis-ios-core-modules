// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArtemisCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Common",
            targets: ["Common"]),
        .library(
            name: "UserStore",
            targets: ["UserStore"]),
        .library(
            name: "APIClient",
            targets: ["APIClient"]),
        .library(
            name: "DesignLibrary",
            targets: ["DesignLibrary"]),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
        .library(
            name: "SharedServices",
            targets: ["SharedServices"]),
        .library(
            name: "PushNotifications",
            targets: ["PushNotifications"]),
        .library(
            name: "ProfileInfo",
            targets: ["ProfileInfo"]),
        .library(
            name: "Login",
            targets: ["Login"]),
        .library(
            name: "Account",
            targets: ["Account"]),
        .library(
            name: "ArtemisMarkdown",
            targets: ["ArtemisMarkdown"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.6.0")),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.9.0")),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.51.0"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/Romixery/SwiftStomp.git", .upToNextMajor(from: "1.0.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Common",
            dependencies: ["SwiftyBeaver"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "UserStore",
            dependencies: ["Common", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "APIClient",
            dependencies: ["Common", "UserStore", "SwiftStomp"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "DesignLibrary",
            dependencies: ["Common", "Kingfisher", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "SharedModels",
            dependencies: ["Common", "UserStore", "DesignLibrary", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "SharedServices", // TODO: make sure that the dependencies are correct
            dependencies: ["Common", "SharedModels", "APIClient", "UserStore"],
            plugins: []
        ),
        .target(
            name: "PushNotifications",
            dependencies: ["CryptoSwift", "APIClient", "Common", "UserStore", "DesignLibrary", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "ProfileInfo",
            dependencies: ["APIClient"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Login",
            dependencies: ["APIClient", "PushNotifications", "ProfileInfo", "UserStore", "DesignLibrary", "SharedModels", "SharedServices", "Account", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Account",
            dependencies: ["APIClient", "PushNotifications", "UserStore", "DesignLibrary", "SharedModels", .product(name: "RswiftLibrary", package: "R.swift")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "ArtemisMarkdown",
            dependencies: ["UserStore", "DesignLibrary", .product(name: "MarkdownUI", package: "swift-markdown-ui")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift"), .plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        )
    ]
)
