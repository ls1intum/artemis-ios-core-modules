// swift-tools-version: 6.4
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
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", .upToNextMajor(from: "2.4.1")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.10.0")),
        .package(url: "https://github.com/mac-cain13/R.swift.git", .upToNextMajor(from: "7.8.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.14.0")),
        .package(url: "https://github.com/Romixery/SwiftStomp.git", .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", .upToNextMinor(from: "0.65.1")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.1.1")),
        .package(url: "https://github.com/1024jp/GzipSwift.git", .upToNextMajor(from: "7.0.0")),
        // 1.13+ emits unused public imports in generated files with current Swift compilers.
        .package(url: "https://github.com/apple/swift-openapi-generator", .upToNextMinor(from: "1.12.2")),
        .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMajor(from: "1.13.3")),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMajor(from: "1.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Account",
            dependencies: [
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
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "Common",
                "SharedModels",
                "SwiftStomp",
                "UserStore",
                .product(name: "Gzip", package: "GzipSwift"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "Common",
            dependencies: [
                "SwiftyBeaver"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "DesignLibrary",
            dependencies: [
                "Common",
                "Kingfisher",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ProfileInfo",
            dependencies: [
                "APIClient"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
                "SharedModels",
                "UserStore",
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "Common",
                "DesignLibrary",
                "UserStore",
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
                .plugin(name: "RswiftGeneratePublicResources", package: "R.swift"),
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "APIClientTests",
            dependencies: ["APIClient"]),
        .testTarget(
            name: "ArtemisMarkdownTests",
            dependencies: ["ArtemisMarkdown"]),
        .testTarget(
            name: "PushNotificationsTests",
            dependencies: ["PushNotifications"])
    ],
    swiftLanguageModes: [.v5]
)
