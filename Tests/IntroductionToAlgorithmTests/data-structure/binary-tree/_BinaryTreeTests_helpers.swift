import XCTest
@testable import IntroductionToAlgorithm

func _assertTreeBfEquals<Element: Equatable>(tree: BinaryTree<Element>, array: [Element], file: StaticString = #filePath, line: UInt = #line) {
  guard let root = tree._store._root else {
    XCTAssertEqual([], array, file: file, line: line)
    return
  }
  let sequence = _binary_tree_node_walk_bf(node: root, initialState: [Element]()) { (ptr, arr) in
    var arr = arr
    arr.append(ptr.pointee._element)
    return .next(arr)
  }

  XCTAssertEqual(sequence, array, file: file, line: line)
}

func _assertTreeDfEquals<Element: Equatable>(tree: BinaryTree<Element>, array: [Element], file: StaticString = #filePath, line: UInt = #line) {
  guard let root = tree._store._root else {
    XCTAssertEqual([], array, file: file, line: line)
    return
  }
  let sequence = _binary_tree_node_walk_df(node: root, initialState: [Element]()) { (ptr, arr) in
    var arr = arr
    arr.append(ptr.pointee._element)
    return .next(arr)
  }

  XCTAssertEqual(sequence, array, file: file, line: line)
}


@inlinable
func _assertTreeEquals<Element: Equatable>(tree: BinaryTree<Element>, element: Element, file: StaticString = #filePath, line: UInt = #line) {
  guard let root = tree._store._root else {
    XCTFail("no element", file: file, line: line)
    return
  }
  XCTAssertEqual(root.pointee._element, element, file: file, line: line)
  XCTAssertNil(root.pointee._l, file: file, line: line)
  XCTAssertNil(root.pointee._r, file: file, line: line)
}

@inlinable
func _buildRandomTree<T>(size: Int, _ gen: () -> T) -> BinaryTree<T> {
  typealias Ptr = _BinaryTreePointer<T>
  let dirs: [BinaryTreeDir] = [.left, .right]
  var size = size - 1
  var pointers = Set<Ptr>()
  let root = _binary_tree_node_allocate(element: gen(), parent: nil)
  pointers.insert(root)
  while size > 0 {
    let node = pointers[pointers.indices.randomElement()!]
    let dir = dirs.randomElement()!
    if node.pointee[dir] != nil {
      continue
    }
    let newNode = _binary_tree_node_allocate(element: gen(), parent: node)
    node.pointee[dir] = newNode
    pointers.insert(newNode)
    if node.pointee[dir.opposite] != nil {
      pointers.remove(node)
    }
    size -= 1
  }
  return BinaryTree(root: root)
}
