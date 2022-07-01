import ArgumentParser
import Foundation
import SwiftSyntax

enum SwatterError: Error {
  case invalidDirectory(URL)
  case invalidPackageManifest

  var errorDescription: String? {
    switch self {
    case let .invalidDirectory(file):
      return "'\(file.relativePath)\' is not a valid directory"
    case .invalidPackageManifest:
      return "Could not find a supported package manager manifest"
    }
  }
}

struct SwatterOptions: ParsableArguments {
  @Option(help: ArgumentHelp("Path of package to analyze"))
  var path = "."
}

let options = SwatterOptions.parseOrExit()

let url = URL.init(string: options.path)

if let hasDirectoryPath = url?.hasDirectoryPath {
  if !hasDirectoryPath {
    throw SwatterError.invalidDirectory(url ?? URL.init(fileURLWithPath: ""))
  }
}

let project = Project(path: url!)
if project == nil {
  throw SwatterError.invalidPackageManifest
}
