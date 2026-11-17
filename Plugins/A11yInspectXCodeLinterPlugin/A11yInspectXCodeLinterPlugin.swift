import PackagePlugin
import Foundation

@main
struct A11yInspectXCodeLinterPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }

        let swiftFiles = sourceTarget.sourceFiles(withSuffix: "swift").map(\.url.path).sorted()
        guard !swiftFiles.isEmpty else {
            return []
        }

        let tool = try context.tool(named: "A11yInspectXCodeLinterRunnerBinary")
        let outputDirectory = context.pluginWorkDirectoryURL.appending(path: "A11yInspectXCodeLinterPluginOutput")
        let reportFile = outputDirectory.appending(path: "a11ylint-report.txt")

        var arguments = ["lint", "--output-format", "xcode", "--output-directory", outputDirectory.path, "--fail-on-error"]
        var inputFiles = sourceTarget.sourceFiles(withSuffix: "swift").map(\.url)

        if let plistURL = findInfoPlist(in: context.package.directoryURL) {
            arguments += ["--plist", plistURL.path]
            inputFiles.append(plistURL)
        }

        for assetCatalog in findAssetCatalogs(in: context.package.directoryURL) {
            arguments += ["--assets", assetCatalog.path]
        }

        arguments += swiftFiles

        return [
            .buildCommand(
                displayName: "Running A11yInspect XCode Linter on \(target.name)",
                executable: tool.url,
                arguments: arguments,
                inputFiles: inputFiles,
                outputFiles: [reportFile]
            )
        ]
    }

    private func findInfoPlist(in directory: URL) -> URL? {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return nil }

        for case let url as URL in enumerator {
            if url.lastPathComponent == "Info.plist" {
                return url
            }
        }
        return nil
    }

    /// `.xcassets` catalogs, so the linter can resolve `Color("Name")` asset colors.
    private func findAssetCatalogs(in directory: URL) -> [URL] {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return [] }

        var catalogs: [URL] = []
        for case let url as URL in enumerator where url.pathExtension == "xcassets" {
            catalogs.append(url)
            enumerator.skipDescendants()
        }
        return catalogs
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension A11yInspectXCodeLinterPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let swiftFiles = target.inputFiles
            .filter { $0.url.pathExtension == "swift" }
            .map(\.url.path)
            .sorted()

        guard !swiftFiles.isEmpty else {
            return []
        }

        let tool = try context.tool(named: "A11yInspectXCodeLinterRunnerBinary")
        let outputDirectory = context.pluginWorkDirectoryURL.appending(path: "A11yInspectXCodeLinterPluginOutput")
        let reportFile = outputDirectory.appending(path: "a11ylint-report.txt")

        var arguments = ["lint", "--output-format", "xcode", "--output-directory", outputDirectory.path, "--fail-on-error"]
        var inputFiles = target.inputFiles.filter { $0.url.pathExtension == "swift" }.map(\.url)

        if let plistURL = findInfoPlist(in: context.xcodeProject.directoryURL) {
            arguments += ["--plist", plistURL.path]
            inputFiles.append(plistURL)
        }

        for assetCatalog in findAssetCatalogs(in: context.xcodeProject.directoryURL) {
            arguments += ["--assets", assetCatalog.path]
        }

        arguments += swiftFiles

        return [
            .buildCommand(
                displayName: "Running A11yInspect XCode Linter on \(target.displayName)",
                executable: tool.url,
                arguments: arguments,
                inputFiles: inputFiles,
                outputFiles: [reportFile]
            )
        ]
    }
}
#endif
