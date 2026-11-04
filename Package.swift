// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HPMedya",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "HPMedyaCore", targets: ["HPMedyaCore"]),
        .executable(name: "HPMedya", targets: ["HPMedyaApp"]),
        .executable(name: "hpmedya-cli", targets: ["HPMedyaCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", exact: "2.10.0")
    ],
    targets: [
        .target(name: "HPMedyaCore", resources: [.copy("Resources")]),
        // The frozen XPC wire protocol stays at its sealed source path. It is compiled
        // into the renamed module without changing its Objective-C identity.
        .target(name: "HPMedyaUpdates", dependencies: [.product(name: "Sparkle", package: "Sparkle")], path: "Sources", exclude: ["HPMedyaApp", "HPMedyaCore", "HPMedyaCLI", "UpdateCredentialBroker"], sources: ["HPMedyaUpdates", "TangerineUpdates/UpdateCredentialBrokerProtocol.swift"]),
        .executableTarget(name: "HPMedyaApp", dependencies: ["HPMedyaCore", "HPMedyaUpdates"], linkerSettings: [.unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"])]),
        .executableTarget(name: "HPMedyaCLI", dependencies: ["HPMedyaCore"]),
        .testTarget(name: "HPMedyaCoreTests", dependencies: ["HPMedyaCore"], resources: [.copy("Fixtures")]),
        .testTarget(name: "HPMedyaUpdatesTests", dependencies: ["HPMedyaUpdates"])
    ],
    swiftLanguageModes: [.v5]
)
