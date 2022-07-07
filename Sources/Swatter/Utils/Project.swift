import Foundation

enum ProjectError: Error {
  case unsupportedProject
  case enumeratorError
}

enum PackageManagerManifest: String, CaseIterable {
  case swiftPackageManager = "Package.swift"
  case cocoaPods = "Podfile"
  case carthage = "Cartfile"
}

struct Project {
  // Project's URL
  var path: URL

  /**
   Initializes a project from an URL
   - Parameter path: URL of the directory to initialize a Project for
   - Returns: An instance of a Project object with the provided URL, or nil if the directory is invalid
   */
  init?(path: URL) {
    if Project.isValidProject(path: path) {
      self.path = path
    } else {
      return nil
    }
  }

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

  /**
   This functions iterates over files and directories to collect a list of .swift source files whilst
   checking whether or not the path is in the exclusion list or contains .build
   - Returns: The collected set of files
   */
  public func collectFiles(exclusions: Set<URL> = []) throws -> Set<URL> {
    let fileManager = FileManager.default
    guard
      let enumerator = fileManager.enumerator(at: path, includingPropertiesForKeys: [], options: [])
    else {
      throw ProjectError.enumeratorError
    }
    var files = Set<URL>()
    while let element = enumerator.nextObject() {
      guard let file = element as? URL else {
        continue
      }

      guard file.lastPathComponent != ".build", !exclusions.contains(path)
      else {
        enumerator.skipDescendants()
        continue
      }

      guard file.pathExtension == "swift" else {
        continue
      }

      files.insert(file)
    }
    return files
  }
}
