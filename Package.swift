// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
// manual build: swift build -Xswiftc "-sdk" -Xswiftc "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator13.0.sdk" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios12.1-simulator"
import PackageDescription

let package = Package(
    name: "ResumableCombine",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ResumableCombine",
            targets: ["ResumableCombine"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/haifengkao/CResumableCombineHelpers.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ResumableCombine",
            dependencies: ["CResumableCombineHelpers"]
        ),
        // .target( ResumableCombineExample need ios14 to run
        //     name: "ResumableCombineExample",
        //     dependencies: ["ResumableCombine"],
        //     path: "Example/Shared"
        // ),
        .testTarget(
            name: "ResumableCombineTests",
            dependencies: [
                "ResumableCombine",
                "Quick",
                "Nimble",
            ]
        ),
    ]
)
