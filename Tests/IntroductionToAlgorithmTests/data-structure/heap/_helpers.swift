import XCTest
@testable import IntroductionToAlgorithm

func testHeap(_ heap: some _HeapProtocol) throws {
  var i = 1
  while i < heap._store._size {
    let p = _heap_parent(i)

    XCTAssert(heap._compare(heap[p], heap[i]), "value pair (\(p), \(i)) should in order")
    try XCTSkipUnless(heap._compare(heap[p], heap[i]))
    i += 1
  }
}