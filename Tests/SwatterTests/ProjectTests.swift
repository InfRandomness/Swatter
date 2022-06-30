import Foundation
import XCTest

@testable import Swatter

class ProjectTests: XCTestCase {
  func testIsValidProject() throws {
    let fileManager = FileManager()
    // Workaround for bundleURL returning the parent of the resource directory
    let testDir = Bundle(for: type(of: self)).bundleURL.appendingPathComponent(
      "Swatter_SwatterTests.resources/ProjectTests/TestIsValidProject")

    XCTAssert(
      Swatter.Project.isValidProject(
        path: testDir.appendingPathComponent("SwiftPM")))
    XCTAssert(
      Swatter.Project.isValidProject(
        path: testDir.appendingPathComponent("CocoaPods")))
    XCTAssert(
      Swatter.Project.isValidProject(
        path: testDir.appendingPathComponent("Carthage")))

    XCTAssertFalse(Swatter.Project.isValidProject(path: testDir))
  }
}
