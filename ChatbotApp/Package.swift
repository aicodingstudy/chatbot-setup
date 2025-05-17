import PackageDescription

let package = Package(
    name: "ChatbotApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ChatbotApp", targets: ["ChatbotApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ChatbotApp",
            dependencies: []
        )
    ]
)
