// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArtemisCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
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
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", .upToNextMajor(from: "2.3.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/mac-cain13/R.swift.git", .upToNextMajor(from: "7.5.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.11.0")),
        .package(url: "https://github.com/Romixery/SwiftStomp.git", .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMinor(from: "0.55.0")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Account",
            dependencies: [
                "APIClient",
                "DesignLibrary",
                "PushNotifications",
                "SharedModels",
                "SharedServices",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "Common",
                "SwiftStomp",
                "UserStore"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "ArtemisMarkdown",
            dependencies: [
                "UserStore",
                "DesignLibrary",
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Common",
            dependencies: [
                "SwiftyBeaver"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "DesignLibrary",
            dependencies: [
                "Common",
                "Kingfisher",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Login",
            dependencies: [
                "Account",
                "APIClient",
                "DesignLibrary",
                "ProfileInfo",
                "PushNotifications",
                "SharedModels",
                "SharedServices",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "ProfileInfo",
            dependencies: [
                "APIClient"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "PushNotifications",
            dependencies: [
                "APIClient",
                "ArtemisMarkdown",
                "Common",
                "CryptoSwift",
                "DesignLibrary",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "Common",
                "DesignLibrary",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "SharedServices",
            dependencies: [
                "APIClient",
                "Common",
                "SharedModels",
                "UserStore"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "UserStore",
            dependencies: [
                "Common",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "ArtemisMarkdownTests",
            dependencies: ["ArtemisMarkdown"])
    ]
)
