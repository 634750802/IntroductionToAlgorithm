import XCTest
@testable import IntroductionToAlgorithm

fileprivate class RefObject {
  static var count = 0

  init() {
    RefObject.count += 1
  }

  deinit {
    RefObject.count -= 1
  }
}

final class _ListStoreTests: XCTestCase {

  func testAutorelease() {
    var store = _UnsafeListStore<RefObject>(capacity: 3)

    store.initialize(element: RefObject(), at: 0)
    XCTAssertEqual(RefObject.count, 1)

    store.deinitialize(at: 0)
    XCTAssertEqual(RefObject.count, 0)

    store.initialize(element: RefObject(), at: 0)
    store.assign(element: RefObject(), at: 0)
    XCTAssertEqual(RefObject.count, 1)

    store.move(at: 0)
    XCTAssertEqual(RefObject.count, 0)
  }

  func testMove() {
    var store = _UnsafeListStore<RefObject>(capacity: 3)
    var refPtr = UnsafeMutablePointer<RefObject>.allocate(capacity: 1)
    defer {
      refPtr.deallocate()
    }
    refPtr.initialize(to: RefObject())

    store.moveInitialize(from: refPtr)
    XCTAssertEqual(RefObject.count, 1)

    store.deinitialize(at: 0)
    XCTAssertEqual(RefObject.count, 0)
  }

  func testMoveAssign() {
    var store = _UnsafeListStore<RefObject>(capacity: 3)
    store.initialize(element: RefObject(), at: 0)
    var refPtr = UnsafeMutablePointer<RefObject>.allocate(capacity: 1)
    defer {
      refPtr.deallocate()
    }
    refPtr.initialize(to: RefObject())
    XCTAssertEqual(RefObject.count, 2)

    store.moveAssign(from: refPtr)
    XCTAssertEqual(RefObject.count, 1)

    store.deinitialize(at: 0)
    XCTAssertEqual(RefObject.count, 0)
  }
}