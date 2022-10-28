// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "SwiftUINavigator",
        platforms: [
            .macOS(.v11),
            .iOS(.v13),
            .tvOS(.v13),
        ],
        products: [
            .library(
                    name: "SwiftUINavigator",
                    targets: ["SwiftUINavigator"]),
        ],
        dependencies: [
        ],
        targets: [
            .target(
                    name: "SwiftUINavigator",
                    dependencies: [],
                    path: "SwiftUINavigator/Sources"
            ),
            .testTarget(
                    name: "SwiftUINavigatorTests",
                    dependencies: ["SwiftUINavigator"],
                    path: "SwiftUINavigator/Sources"
            ),
        ]
)
