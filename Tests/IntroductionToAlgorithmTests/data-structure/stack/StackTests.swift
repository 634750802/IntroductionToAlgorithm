import XCTest
@testable import IntroductionToAlgorithm

final class StackTests: XCTestCase {

  func testPush() {
    var stack = Stack<Int>()

    stack.push(1)
    stack.push(2)
    stack.push(3)

    XCTAssertEqual(Array(stack), [1, 2, 3])
  }

  func testPop() {
    var stack = Stack([1, 2, 3, 4])
    XCTAssertEqual(stack.pop(), 4)
    XCTAssertEqual(Array(stack), [1, 2, 3])
  }

  func testCopyOnWrite() {
    let a = Stack<Int>()
    var b = a
    XCTAssert(a._store === b._store)

    b.push(1)
    XCTAssert(a._store !== b._store)

    XCTAssertTrue(a._store._array.isEmpty)
    XCTAssertFalse(b._store._array.isEmpty)
  }
}