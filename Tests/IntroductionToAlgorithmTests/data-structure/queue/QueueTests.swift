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
    XCTAssertEqual(Array(Queue<Int>([1, 2, 3])), [1, 2, 3])
  }

  func testCopyOnWrite() {
    var a = Queue<Int>([1, 2, 3])
    XCTAssertTrue(a.isFull)
    var b = a

    XCTAssertEqual(1, a.dequeue())
    XCTAssertFalse(a._store === b._store)
    XCTAssertEqual(2, a.dequeue())
    XCTAssertEqual(3, a.dequeue())

    XCTAssertEqual(1, b.dequeue())
    XCTAssertEqual(2, b.dequeue())
    XCTAssertEqual(3, b.dequeue())
  }

  func testDeinit() {
    var a: Queue<Int>? = Queue<Int>(capacity: 1)
    a = nil
    a = Queue<Int>([1, 2, 3])
    a = nil
    XCTAssertNil(a)
  }

  func testIncreaseIfNeed() {
    var a = Queue<Int>([1, 2, 3])
    a.increaseSizeIfNeed(factor: 2)
    XCTAssertEqual(a._store._capacity, 6)
    XCTAssertFalse(a.isFull)
    XCTAssertEqual(a.dequeue(), 1)
  }

  func testResize() {
    var a = Queue([1, 2, 3])
    var b = a
    b._cloneIfNeeds()

    a.resize(capacity: 5)
    b = a
    b._cloneIfNeeds()
    XCTAssertFalse(a.isFull)
    XCTAssertEqual(Array(a), [1, 2, 3])
    XCTAssertFalse(b.isFull)
    XCTAssertEqual(Array(b), [1, 2, 3])


    a.resize(capacity: 4)
    b = a
    b._cloneIfNeeds()
    XCTAssertFalse(a.isFull)
    XCTAssertEqual(Array(a), [1, 2, 3])
    XCTAssertFalse(b.isFull)
    XCTAssertEqual(Array(b), [1, 2, 3])

    a.enqueue(4)
    b = a
    b._cloneIfNeeds()
    XCTAssertTrue(a.isFull)
    XCTAssertEqual(Array(a), [1, 2, 3, 4])
    XCTAssertTrue(b.isFull)
    XCTAssertEqual(Array(b), [1, 2, 3, 4])

    a.dequeue()
    a.resize(capacity: 3)
    b = a
    b._cloneIfNeeds()
    XCTAssertTrue(a.isFull)
    XCTAssertEqual(Array(a), [2, 3, 4])
    XCTAssertTrue(b.isFull)
    XCTAssertEqual(Array(b), [2, 3, 4])

    a.dequeue()
    a.dequeue()
    a.enqueue(5)
    a.resize(capacity: 2)
    b = a
    b._cloneIfNeeds()
    XCTAssertTrue(a.isFull)
    XCTAssertEqual(Array(a), [4, 5])
    XCTAssertTrue(b.isFull)
    XCTAssertEqual(Array(b), [4, 5])

    a.resize(capacity: 3)
    b = a
    b._cloneIfNeeds()
    XCTAssertFalse(a.isFull)
    XCTAssertEqual(Array(a), [4, 5])
    XCTAssertFalse(b.isFull)
    XCTAssertEqual(Array(b), [4, 5])

    a.dequeue()
    a.dequeue()
    a.resize(capacity: 1)
    b = a
    b._cloneIfNeeds()
    XCTAssertTrue(a.isEmpty)
    XCTAssertEqual(Array(a), [])
    XCTAssertTrue(b.isEmpty)
    XCTAssertEqual(Array(b), [])

    a = Queue([1, 2, 3])
    a.dequeue()
    a.enqueue(4)
    a.resize(capacity: 5)
    b = a
    b._cloneIfNeeds()
    XCTAssertEqual(Array(a), [2, 3, 4])
    XCTAssertEqual(Array(b), [2, 3, 4])

    a = Queue([1, 2, 3])
    a._store._head = 1
    a._store._tail = 1
    b = a
    b._cloneIfNeeds()
    XCTAssertEqual(Array(a), [2, 3, 1])
    XCTAssertEqual(Array(b), [2, 3, 1])
  }

  func testCount() {
    var a = Queue([1, 2])
    XCTAssertEqual(a.count, 2)
    a.dequeue()
    XCTAssertEqual(a.count, 1)
    a.dequeue()
    XCTAssertEqual(a.count, 0)
  }
}