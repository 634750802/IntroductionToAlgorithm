import XCTest
@testable import IntroductionToAlgorithm

final class _LinkStoreTests: XCTestCase {
  func buildSimple() -> _LinkStore<Int> {
    let link = _LinkStore<Int>()
    link.insert(5, at: 0)
    link.insert(4, at: 0)
    link.insert(3, at: 0)
    link.insert(2, at: 0)
    link.insert(1, at: 0)

    return link
  }

  func testInsert() {
    let link = buildSimple()

    XCTAssertEqual(Array(link), [1, 2, 3, 4, 5])

    link.insert(6, at: 3)
    XCTAssertEqual(Array(link), [1, 2, 3, 6, 4, 5])

    XCTAssertEqual(_debug_link_node_count, 6)
  }

  func testDelete() {
    let link = buildSimple()

    link.delete(at: 3)
    XCTAssertEqual(Array(link), [1, 2, 3, 5])

    XCTAssertEqual(_debug_link_node_count, 4)

    link.delete(at: 0)
    XCTAssertEqual(Array(link), [2, 3, 5])
    XCTAssertEqual(_debug_link_node_count, 3)
  }

  func testDestroy() {
    var link: _LinkStore<Int>?
    link = buildSimple()
    XCTAssertEqual(_debug_link_node_count, 5)

    link = nil
    XCTAssertNil(link)
    XCTAssertEqual(_debug_link_node_count, 0)
  }

  func testClone() {
    let a: _LinkStore<Int> = buildSimple()
    let b: _LinkStore<Int> = _LinkStore.init(a)

    XCTAssertNotEqual(a._root, b._root)
    XCTAssertEqual(_debug_link_node_count, 10)
  }

  override func tearDown() {
    super.tearDown()
    XCTAssertEqual(_debug_link_node_count, 0, "link memory leak")
  }
}