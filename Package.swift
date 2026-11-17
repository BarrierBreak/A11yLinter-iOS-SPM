// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "A11yInspectXCodeLinter",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .plugin(
            name: "A11yInspectXCodeLinterPlugin",
            targets: ["A11yInspectXCodeLinterPlugin"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "A11yInspectXCodeLinterRunnerBinary",
            url: "https://github.com/BarrierBreak/A11yLinter-iOS-SPM/releases/download/1.0.0/A11yInspectXCodeLinterRunner.artifactbundle.zip",
            checksum: "ab526a3b5655325937f526556d1d8ae962ffd11c8bad9b6db97f4412b39f0e65"
        ),
        .plugin(
            name: "A11yInspectXCodeLinterPlugin",
            capability: .buildTool(),
            dependencies: ["A11yInspectXCodeLinterRunnerBinary"]
        )
    ]
)
