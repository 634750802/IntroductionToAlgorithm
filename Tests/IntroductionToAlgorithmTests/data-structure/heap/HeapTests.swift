import XCTest
@testable import IntroductionToAlgorithm

final class HeapTests: XCTestCase {
  func testExampleInBook() throws {
    let heap = MaxHeap<Int>([16, 4, 10, 14, 7, 9, 3, 2, 8, 1])
    XCTAssertEqual([16, 14, 10, 8, 7, 9, 3, 2, 4, 1], .init(heap))
    try testHeap(heap)
  }

  func testRandomHeap() throws {
    for _ in 0..<10 {
      let arr = (0..<232).map { _ in Int.random(in: 100..<999) }
      let heap = MaxHeap(arr)
      try testHeap(heap)
    }
  }

  func testInsert() throws {
    for _ in 0..<10 {
      var heap = MaxHeap<Int>()
      for i in 0..<243 {
        XCTAssertEqual(heap._store._size, i)
        heap.insert(Int.random(in: 100..<999))
        try testHeap(heap)
      }
    }
  }

  func testPop() {
    for _ in 0..<10 {
      var heap = MinHeap<Int>()
      var raw = [Int]()
      for _ in 0..<286 {
        let el = Int.random(in: 100..<999)
        heap.insert(el)
        raw.append(el)
      }

      XCTAssertNotEqual(Array(heap), raw.sorted())

      var arr: [Int] = []
      while let element = heap.pop() {
        arr.append(element)
      }

      XCTAssertEqual(raw.sorted(), arr)
    }
  }

  func testCopyOnWrite() {
    let a = MaxHeap<Int>()
    var b = a
    XCTAssertTrue(a._store === b._store)
    b.insert(0)
    XCTAssertTrue(a._store !== b._store)
    XCTAssertEqual(a._store._size, 0)
    XCTAssertEqual(b._store._size, 1)
  }
}
