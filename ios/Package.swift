// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "MyApp",

    platforms: [
        .iOS(.v17)
    ],

    products: [
        .library(
            name: "MyApp",
            targets: ["MyApp"]
        )
    ],

    dependencies: [
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "8.11.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            exact: "12.17.0"
        ),
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            from: "7.0.0"
        )
    ],

    targets: [
        .target(
            name: "MyApp",

            dependencies: [
                .product(
                    name: "Kingfisher",
                    package: "Kingfisher"
                ),
                .product(
                    name: "GRDB",
                    package: "GRDB.swift"
                ),
                .product(
                    name: "FirebaseCore",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseAnalytics",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseCrashlytics",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseRemoteConfig",
                    package: "firebase-ios-sdk"
                )
            ],

            path: "MyApp",

            exclude: [
                "Resources/GoogleService-Info.plist",
                "Resources/PrivacyInfo.xcprivacy",
                "Resources/LaunchScreen.storyboard"
            ],

            resources: [
                .copy("Resources/Localizable.xcstrings")
            ]
        ),
    ],

    swiftLanguageModes: [
        .v6
    ]
)