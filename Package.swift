// swift-tools-version:5.1
import PackageDescription

let buildTests = false

let package = Package(
        name: "SwiftUIFormValidator",
        platforms: [
            .macOS(.v10_14), .iOS(.v13), .tvOS(.v13)
        ],
        products: [
            .library(name: "FormValidator", targets: ["FormValidator"])
        ],
        dependencies: [],
        targets: [
            .target(
                    name: "FormValidator",
                    dependencies: [],
                    path: "Sources",
                    exclude: ["Tests", "Examples"])
        ]
)
