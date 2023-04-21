# ArtemisCore

ArtemisCore is a SPM package containing modules which can be used accross all Artemis related iOS apps.

# Modules Overview

- **APIClient**: A lightweight API client based on Apple's URLSesssion
- **Common**: Contains common functionality like logging, utility functions and network-state wrappers
- **DesignLibrary**: Contains Artemis-Web lookalike UI Elements, like buttons, textfields, etc... 
- **UserStore**: Is used for storing user session related data, like login data and push notification information
- **PushNotifications**: Contains all handlers to receive notifications from the Artemis server
- **SharedModels**: Contains the domain models used by the server
- **ProfileInfo**: A small service to receive the Artemis instance information
- **Login**: Contains Views and services to authenticate the user with an Artemis instance

TODO: UML Package Diagram

# Installation Guide

## Swift Package Manager

### Add to Xcode project

In Project Settings, on the tab "Package Dependencies", click "+" and add <https://github.com/ls1intum/artemis-ios-core-modules>

### Add to Package.swift based SPM project

1. Add a dependency in Package.swift:
``
dependencies: [
    .package(url: "https://github.com/ls1intum/artemis-ios-core-modules", .upToNextMajor(from: "0.1.0")),
]
``
2. For each relevant target, add a dependency with the product name from section 1, e.g.:
``
.target(
    name: "Example",
    dependencies: [
        .product(name: "SharedModels", package: "artemis-ios-core-modules"),
    ]    
)
``

# How to use Modules

TODO
