import XCTest
@testable import IntroductionToAlgorithm

func _assertBfEquals<Element: Equatable>(tree: BinaryTree<Element>, array: [Element]) {
  guard let root = tree._store._root else {
    XCTAssertEqual([], array)
    return
  }
  let sequence = _binary_tree_node_walk_bf(node: root, initialState: [Element]()) { (ptr, arr) in
    var arr = arr
    arr.append(ptr.pointee._element)
    return .next(arr)
  }

  XCTAssertEqual(sequence, array)
}

func _assertDfEquals<Element: Equatable>(tree: BinaryTree<Element>, array: [Element]) {
  guard let root = tree._store._root else {
    XCTAssertEqual([], array)
    return
  }
  let sequence = _binary_tree_node_walk_df(node: root, initialState: [Element]()) { (ptr, arr) in
    var arr = arr
    arr.append(ptr.pointee._element)
    return .next(arr)
  }

  XCTAssertEqual(sequence, array)
}
