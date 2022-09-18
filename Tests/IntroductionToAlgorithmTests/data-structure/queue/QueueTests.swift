import XCTest
@testable import IntroductionToAlgorithm

final class QueueTests: XCTestCase {
  func testEnqueue() {
    var store = Queue<Int>()

    XCTAssertTrue(store.enqueue(1))
    XCTAssertTrue(store.enqueue(2))
    XCTAssertTrue(store.enqueue(3))

    XCTAssertEqual(Array(store), [1, 2, 3])
  }

  func testDequeue() {
    var store = Queue<Int>()

    XCTAssertTrue(store.enqueue(1))
    XCTAssertTrue(store.enqueue(2))
    XCTAssertTrue(store.enqueue(3))
    XCTAssertEqual(1, store.dequeue())

    XCTAssertEqual(Array(store), [2, 3])

    XCTAssertTrue(store.enqueue(1))

    XCTAssertEqual(Array(store), [2, 3, 1])
  }

  func testState() {
    var store = Queue<Int>(capacity: 3)
    XCTAssertTrue(store.isEmpty)
    XCTAssertNil(store.dequeue())
    XCTAssertTrue(store.enqueue(1))
    XCTAssertTrue(store.enqueue(2))
    XCTAssertTrue(store.enqueue(3))
    XCTAssertTrue(store.isFull)
    XCTAssertFalse(store.enqueue(4))
    XCTAssertEqual(Array(store), [1, 2, 3])
  }

  func testRotate() {
    var store = Queue<Int>(capacity: 3)
    XCTAssertTrue(store.enqueue(1))
    XCTAssertTrue(store.enqueue(2))
    XCTAssertTrue(store.enqueue(3))
    XCTAssertFalse(store.enqueue(4))
    XCTAssertNotNil(store.dequeue())
    XCTAssertTrue(store.enqueue(4))
    XCTAssertFalse(store.enqueue(5))
    XCTAssertEqual(Array(store._store._buffer), [4, 2, 3])
    XCTAssertEqual(Array(store), [2, 3, 4])
  }

  func testSequenceInit() {
    XCTAssertTrue(Queue<Int>([1, 2, 3]).isFull)
  }
}

  func testCopyOnWrite() {
    var a = Queue<Int>([1, 2, 3])
    XCTAssertTrue(a.isFull)
    var b = a

    XCTAssertEqual(1, a.dequeue())
    XCTAssertEqual(2, a.dequeue())
    XCTAssertEqual(3, a.dequeue())

    XCTAssertEqual(1, b.dequeue())
    XCTAssertEqual(2, b.dequeue())
    XCTAssertEqual(3, b.dequeue())
//  }
}