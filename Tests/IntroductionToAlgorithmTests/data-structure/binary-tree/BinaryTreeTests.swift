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
  func testBuildTree() {
    let tree = demoTree()

    _assertDfEquals(tree: tree, array: [0, 1, 2, 3, 4])
    _assertBfEquals(tree: tree, array: [0, 1, 4, 2, 3])
  }

  func testRemove() {
    var tree = demoTree()
    tree.remove(path: [.left, .left])
    tree.remove(path: [.right])

    _assertDfEquals(tree: tree, array: [0, 1, 3])
    _assertBfEquals(tree: tree, array: [0, 1, 3])

    tree.remove(path: [])

    _assertDfEquals(tree: tree, array: [])
    _assertBfEquals(tree: tree, array: [])
  }

  func testMutate() {
    var tree = demoTree()
    tree.mutate(path: [.right]) { i in i = 5 }

    _assertDfEquals(tree: tree, array: [0, 1, 2, 3, 5])
    _assertBfEquals(tree: tree, array: [0, 1, 5, 2, 3])
  }

  func testCOW() {
    let a = demoTree()
    var b = a
    b.mutate(path: [.right]) { i in i = 5 }

    _assertDfEquals(tree: a, array: [0, 1, 2, 3, 4])
    _assertBfEquals(tree: a, array: [0, 1, 4, 2, 3])
    _assertDfEquals(tree: b, array: [0, 1, 2, 3, 5])
    _assertBfEquals(tree: b, array: [0, 1, 5, 2, 3])
  }

  func testDeallocate() {
    var a: BinaryTree<Int>? = demoTree()
    a = nil
    XCTAssertNil(a)
  }
}