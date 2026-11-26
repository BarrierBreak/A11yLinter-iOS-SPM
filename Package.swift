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
        ),
        .plugin(
            name: "A11yInspectActivateLicense",
            targets: ["A11yInspectActivateLicense"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "A11yInspectXCodeLinterRunnerBinary",
            url: "https://github.com/BarrierBreak/A11yLinter-iOS-SPM/releases/download/1.0.3/A11yInspectXCodeLinterRunner.artifactbundle.zip",
            checksum: "688aea2edea67fcf8efd4129e756103d134d5840c08501eed0965a72a77512bb"
        ),
        .plugin(
            name: "A11yInspectXCodeLinterPlugin",
            capability: .buildTool(),
            dependencies: ["A11yInspectXCodeLinterRunnerBinary"]
        ),
        .plugin(
            name: "A11yInspectActivateLicense",
            capability: .command(
                intent: .custom(
                    verb: "a11ylint-activate",
                    description: "Activate the A11yInspect linter with the API key in .a11ylint.json"
                ),
                permissions: [
                    .allowNetworkConnections(
                        scope: .all(ports: [443]),
                        reason: "Checks your A11yInspect API key with the license server"
                    ),
                    .writeToPackageDirectory(
                        reason: "Saves the license activation to .a11ylint-activation.json"
                    )
                ]
            ),
            dependencies: ["A11yInspectXCodeLinterRunnerBinary"]
        )
    ]
)
