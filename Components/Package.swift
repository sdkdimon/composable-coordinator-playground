// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Components",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(name: "Helpers", targets: ["Helpers"]),
    .library(name: "ObservableScreens", targets: ["ObservableScreens"]),
    .library(name: "Coordinator", targets: ["Coordinator"]),
    .library(name: "AppCoordinator", targets: ["AppCoordinator"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.21.1"),
  ],
  targets: [
    .target(
      name: "Helpers"
    ),
    .target(
      name: "ObservableScreens",
      dependencies: [
        "Helpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "Coordinator",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AppCoordinator",
      dependencies: [
        "ObservableScreens",
        "Coordinator",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    )
  ]
)
