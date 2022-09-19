@usableFromInline
protocol _QueueProtocol<Element>: QueueProtocol, Sequence, _StoredProtocol where Store == _QueueStore<Element> {
  init(_store: Store)
}

extension _QueueProtocol {
  @discardableResult
  @inlinable
  public mutating func enqueue(_ element: Element) -> Bool {
    guard !isFull else {
      return false
    }
    _cloneIfNeeds()
    _store.set(element: element, at: _store._tail)
    _store._tail = (_store._tail + 1) % _store._capacity
    return true
  }

  @discardableResult
  @inlinable
  public mutating func dequeue() -> Element? {
    guard !isEmpty else {
      return nil
    }
    _cloneIfNeeds()
    let e = _store._buffer[_store._head]
    _store.delete(at: _store._head)
    _store._head = (_store._head + 1) % _store._capacity
    return e
  }

  @inlinable
  public mutating func resize(capacity: Int) {
    _cloneIfNeeds()
    let count = count
    guard capacity >= count else { fatalError("new capacity must greater than current size") }
    let store = _QueueStore<Element>(capacity: capacity)
    store.moveInitialize(from: _store)
    self = .init(_store: store)
  }

  @inlinable
  public mutating func increaseSizeIfNeed(factor: Float) {
    if isFull {
      resize(capacity: Int(Float(_store._capacity) * factor))
    }
  }

  @inlinable
  public func makeIterator() -> QueueIterator<Element> {
    QueueIterator(_store)
  }

  @inlinable
  public var isFull: Bool {
    _store._tail == _store._head && _store._lastOp == .enqueue
  }

  @inlinable
  public var isEmpty: Bool {
    _store._tail == _store._head && _store._lastOp == .dequeue
  }

  @inlinable
  public var count: Int {
    if _store._tail == _store._head {
      return _store._lastOp == .enqueue ? _store._capacity : 0
    }
    return (_store._tail - _store._head + _store._capacity) % _store._capacity
  }
}