import PackagePlugin
import Foundation

/// One-time license activation. Build plugins run without network access, so
/// this command checks the API key in `.a11ylint.json` with the server and saves
/// the result as `.a11ylint-activation.json` for builds to use.
///
///   SwiftPM: swift package --allow-network-connections all:443 --allow-writing-to-package-directory a11ylint-activate
///   Xcode:   right-click the project > Activate A11yInspect License
@main
struct A11yInspectActivateLicense: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        try activate(
            tool: context.tool(named: "A11yInspectXCodeLinterRunnerBinary").url,
            projectDirectory: context.package.directoryURL
        )
    }

    fileprivate func activate(tool: URL, projectDirectory: URL) throws {
        let process = Process()
        process.executableURL = tool
        process.arguments = ["activate", "--package-path", projectDirectory.path]
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw ActivationFailed()
        }
    }

    private struct ActivationFailed: Error, CustomStringConvertible {
        var description: String { "A11yInspect license activation failed. See the message above." }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension A11yInspectActivateLicense: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try activate(
            tool: context.tool(named: "A11yInspectXCodeLinterRunnerBinary").url,
            projectDirectory: context.xcodeProject.directoryURL
        )
    }
}
#endif
