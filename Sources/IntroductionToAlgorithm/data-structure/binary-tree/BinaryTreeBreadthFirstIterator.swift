public struct BinaryTreeBreadthFirstIterator<Element>: IteratorProtocol {
  @usableFromInline
  var _queue: Queue<_BinaryTreePointer<Element>>

  @inlinable
  init(_ root: _BinaryTreePointer<Element>?) {
    _queue = .init(capacity: 8)
    if let root {
      _queue.enqueue(root)
    }
  }

  @inlinable
  public mutating func next() -> Element? {
    guard let node = _queue.dequeue() else { return nil }
    if let l = node.pointee._l {
      _queue.increaseSizeIfNeed(factor: 2)
      _queue.enqueue(l)
    }
    if let r = node.pointee._r {
      _queue.increaseSizeIfNeed(factor: 2)
      _queue.enqueue(r)
    }
    return node.pointee._element
  }
}