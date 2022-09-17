public struct QueueIterator<Element>: IteratorProtocol {
  @usableFromInline
  let _store: _QueueStore<Element>

  @usableFromInline
  var _current: Int

  @usableFromInline
  var _hasAny: Bool

  @inlinable
  init(_ store: _QueueStore<Element>) {
    _store = store
    _current = _store._head
    _hasAny = _store._lastOp == .enqueue
  }

  @inlinable
  public mutating func next() -> Element? {
    guard _current != _store._tail || _hasAny else { return nil }
    let e = _store._array[_current]
    _current = (_current + 1) % _store._capacity
    _hasAny = false
    return e
  }
}