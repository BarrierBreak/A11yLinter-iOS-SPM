# A11yInspect Xcode Linter

Accessibility linter for iOS projects, run as a Swift Package build-tool plugin.

## Installation

In Xcode: **File > Add Package Dependencies…** and enter:

    https://github.com/BarrierBreak/A11yLinter-iOS-SPM

Pick version `1.0.0` or later, then add **A11yInspectXCodeLinterPlugin** under
your app target's **Build Phases > Run Build Tool Plug-ins**.

For Swift packages:

```swift
dependencies: [
    .package(url: "https://github.com/BarrierBreak/A11yLinter-iOS-SPM", from: "1.0.0")
],
targets: [
    .target(
        name: "MyApp",
        plugins: [.plugin(name: "A11yInspectXCodeLinterPlugin", package: "A11yInspectXCodeLinter")]
    )
]
```
