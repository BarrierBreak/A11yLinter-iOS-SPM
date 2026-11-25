# A11yInspect Xcode Linter

Accessibility linter for iOS projects, run as a Swift Package build-tool plugin.

## Installation

In Xcode: **File > Add Package Dependencies…** and enter:

    https://github.com/BarrierBreak/A11yLinter-iOS-SPM

Pick version `1.0.1` or later, then add **A11yInspectXCodeLinterPlugin** under
your app target's **Build Phases > Run Build Tool Plug-ins**.

For Swift packages:

```swift
dependencies: [
    .package(url: "https://github.com/BarrierBreak/A11yLinter-iOS-SPM", from: "1.0.1")
],
targets: [
    .target(
        name: "MyApp",
        plugins: [.plugin(name: "A11yInspectXCodeLinterPlugin", package: "A11yInspectXCodeLinter")]
    )
]
```

## Activate your license

1. Copy your API key from the A11yInspect portal into `.a11ylint.json` in your project root:

   ```json
   { "licenseKey": "<your API key>" }
   ```

2. Activate it once (needs internet):
   - **Xcode:** right-click your project in the navigator and choose **Activate A11yInspect License**.
   - **Terminal:** `swift package --allow-network-connections all:443 --allow-writing-to-package-directory a11ylint-activate`

   This creates `.a11ylint-activation.json` next to `.a11ylint.json`. Run it again after
   renewing your subscription or changing the key.

3. Build. Until the key is activated, the linter shows a warning and reports nothing.
