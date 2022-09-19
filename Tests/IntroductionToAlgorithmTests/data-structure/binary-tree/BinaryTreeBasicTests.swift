import XCTest
@testable import IntroductionToAlgorithm

final class BinaryTreeBasicsTests: XCTestCase {

  func testDir () {
    XCTAssertEqual(BinaryTreeDir.left.opposite, .right)
    XCTAssertEqual(BinaryTreeDir.right.opposite, .left)
  }
}