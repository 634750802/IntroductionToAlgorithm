public struct BinaryTreeDepthFirstIterator<Element>: IteratorProtocol {
  @usableFromInline
  var _stack: Stack<_BinaryTreePointer<Element>>

  @inlinable
  init(_ root: _BinaryTreePointer<Element>?) {
    _stack = .init()
    if let root {
      _stack.push(root)
    }
  }

  @inlinable
  public mutating func next() -> Element? {
    guard let node = _stack.pop() else { return nil }
    if let r = node.pointee._r {
      _stack.push(r)
    }
    if let l = node.pointee._l {
      _stack.push(l)
    }
    return node.pointee._element
  }
}