SwiftUIFormValidator
================
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

## Installation

### Swift Package Manager

To integrate using Apple's Swift package manager, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/ShabanKamell/SwiftUIFormValidator.git", .upToNextMajor(from: "0.8.0"))
```

and then specify `"SwiftUIFormValidator"` as a dependency of the Target in which you wish to use SwiftUIFormValidator.
Here's an example `PackageDescription`:

```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ShabanKamell/SwiftUIFormValidator", .upToNextMajor(from: "0.8.0"))
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: ["SwiftUIFormValidator"])
    ]
)
```
Don't forget to add `import FormValidator` to use the framework.

### Accio

[Accio](https://github.com/JamitLabs/Accio) is a dependency manager based on SwiftPM which can build frameworks for iOS/macOS/tvOS/watchOS. Therefore the integration steps of SwiftUIFormValidator are exactly the same as described above. Once your `Package.swift` file is configured, run `accio update` instead of `swift package update`.

Don't forget to add `import FormValidator` to use the framework.

### CocoaPods

For SwiftUIFormValidator, use the following entry in your Podfile:

```rb
pod 'SwiftUIFormValidator'
```

Then run `pod install`.

Don't forget to add `import FormValidator` to use the framework.

### Carthage

Carthage users can point to this repository and use generated `SwiftUIFormValidator` framework.

Make the following entry in your Cartfile:

```
github "ShabanKamell/SwiftUIFormValidator"
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
