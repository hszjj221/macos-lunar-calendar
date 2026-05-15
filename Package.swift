// swift-tools-version: 6.0
import PackageDescription
import Foundation

let developerDir = ProcessInfo.processInfo.environment["DEVELOPER_DIR"] ?? "/Library/Developer/CommandLineTools"
let candidateFrameworkPaths = [
    "\(developerDir)/Library/Developer/Frameworks",
    "\(developerDir)/Platforms/MacOSX.platform/Developer/Library/Frameworks",
]
let testingFrameworkPath = candidateFrameworkPaths.first {
    FileManager.default.fileExists(atPath: "\($0)/Testing.framework")
}
let testingSwiftSettings: [SwiftSetting] = testingFrameworkPath.map {
    [.unsafeFlags([
        "-I", "\($0)/Testing.framework/Modules",
        "-I", "\($0)/_Testing_Foundation.framework/Modules",
        "-F", $0,
    ])]
} ?? []
let testingLinkerSettings: [LinkerSetting] = testingFrameworkPath.map {
    [.unsafeFlags(["-F", $0, "-framework", "Testing", "-Xlinker", "-rpath", "-Xlinker", $0])]
} ?? []

let package = Package(
    name: "CalendarApp",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "CalendarApp",
            path: "Sources/CalendarApp",
            exclude: ["Resources/Info.plist"]
        ),
        .testTarget(
            name: "CalendarAppTests",
            dependencies: ["CalendarApp"],
            swiftSettings: testingSwiftSettings,
            linkerSettings: testingLinkerSettings
        )
    ]
)
