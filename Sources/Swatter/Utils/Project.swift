import Foundation

enum ProjectError: Error {
  case unsupportedProject
}

enum PackageManagerManifest: String, CaseIterable {
  case swiftPackageManager = "Package.swift"
  case cocoaPods = "Podfile"
  case carthage = "Cartfile"
}

enum Project {
  /**
   This function checks whether or not a URL to a directory contains a Swift project.
   The checking is done by verifying the existence of either (in order) :
   1. A `Package.swift` file (Swift PM project)
   2. A `Podfile` file (CocoaPods project)
   3. A `Cartfile` file (Carthage project)
   - Parameter path: The URL to the directory containing said project
   - Returns: Whether or not the provided URL is a valid Swift project
   */
  public static func isValidProject(path: URL) -> Bool {
    let fileManager = FileManager.default
    for manifest in PackageManagerManifest.allCases {
      let file = path.appendingPathComponent(manifest.rawValue)
      if fileManager.fileExists(atPath: file.path) {
        return true
      }
    }
    return false
  }
}
