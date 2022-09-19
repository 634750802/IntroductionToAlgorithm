import XCTest
@testable import IntroductionToAlgorithm

fileprivate func demoTree() -> BinaryTree<Int> {
  var tree = BinaryTree<Int>()
  tree.insert(path: [], element: 0)
  tree.insert(path: [.left], element: 1)
  tree.insert(path: [.left, .left], element: 2)
  tree.insert(path: [.left, .right], element: 3)
  tree.insert(path: [.right], element: 4)
  return tree
}

final class BinaryTreeTests: XCTestCase {
  override func tearDown() {
    XCTAssertEqual(_debug_binary_tree_node_count, 0)
  }

  func testBuildTree() {
    let tree = demoTree()
    XCTAssertEqual(_debug_binary_tree_node_count, 5)

    _assertTreeDfEquals(tree: tree, array: [0, 1, 2, 3, 4])
    _assertTreeBfEquals(tree: tree, array: [0, 1, 4, 2, 3])
  }

  func testInsert() {
    var tree = demoTree()
    var tree2: BinaryTree<Int>? = demoTree()
    tree.insert(path: [.right, .right], tree: &tree2!)
    tree2 = nil
    XCTAssertEqual(_debug_binary_tree_node_count, 10)

    _assertTreeDfEquals(tree: tree, array: [0, 1, 2, 3, 4, 0, 1, 2, 3, 4])
  }

  func testRemove() {
    var tree = demoTree()
    _assertTreeEquals(tree: tree.remove(path: [.left, .left]), element: 2)
    _assertTreeEquals(tree: tree.remove(path: [.right]), element: 4)
    XCTAssertEqual(_debug_binary_tree_node_count, 3)

    _assertTreeDfEquals(tree: tree, array: [0, 1, 3])
    _assertTreeBfEquals(tree: tree, array: [0, 1, 3])

    _assertTreeDfEquals(tree: tree.remove(path: []), array: [0, 1, 3])
    XCTAssertEqual(_debug_binary_tree_node_count, 0)

    _assertTreeDfEquals(tree: tree, array: [])
    _assertTreeBfEquals(tree: tree, array: [])
  }

  func testMutate() {
    var tree = demoTree()
    tree.mutate(path: [.right]) { i in i = 5 }
    XCTAssertEqual(_debug_binary_tree_node_count, 5)

    _assertTreeDfEquals(tree: tree, array: [0, 1, 2, 3, 5])
    _assertTreeBfEquals(tree: tree, array: [0, 1, 5, 2, 3])
  }

  func testCOW() {
    let a = demoTree()
    var b = a
    XCTAssertEqual(_debug_binary_tree_node_count, 5)

    b.mutate(path: [.right]) { i in i = 5 }
    XCTAssertEqual(_debug_binary_tree_node_count, 10)

    _assertTreeDfEquals(tree: a, array: [0, 1, 2, 3, 4])
    _assertTreeBfEquals(tree: a, array: [0, 1, 4, 2, 3])
    _assertTreeDfEquals(tree: b, array: [0, 1, 2, 3, 5])
    _assertTreeBfEquals(tree: b, array: [0, 1, 5, 2, 3])
  }

  func testDeallocate() {
    var a: BinaryTree<Int>? = demoTree()
    XCTAssertEqual(_debug_binary_tree_node_count, 5)
    a = nil
    XCTAssertEqual(_debug_binary_tree_node_count, 0)
    XCTAssertNil(a)
  }

  func testIterators() {
    let tree: BinaryTree<Int> = demoTree()

    _assertTreeDfEquals(tree: tree, array: Array(tree))
    _assertTreeDfEquals(tree: tree, array: Array(tree.dfView))
    _assertTreeBfEquals(tree: tree, array: Array(tree.bfView))
  }

  func testDepth() {
    func depth<T>(_ node: _BinaryTreePointer<T>?) -> Int {
      guard let node else { return 0 }
      return max(depth(node.pointee._l) + 1, depth(node.pointee._r) + 1)
    }

    for _ in 0..<10 {
      let tree = _buildRandomTree(size: 2000, { Int.random(in: 0..<2000) })
      XCTAssertEqual(tree.depth, depth(tree._store._root))
    }
  }

}