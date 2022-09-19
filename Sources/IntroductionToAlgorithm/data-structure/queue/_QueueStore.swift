@usableFromInline
enum _QueueOp {
  case enqueue
  case dequeue
}

@usableFromInline
final class _QueueStore<Element>: _UnsafeListStore<Element>, _Store {

  @usableFromInline
  let _capacity: Int

  @usableFromInline
  var _head: Int

  @usableFromInline
  var _tail: Int

  @usableFromInline
  var _lastOp: _QueueOp

  @usableFromInline
  override init(capacity: Int) {
    _capacity = capacity
    _head = 0
    _tail = 0
    _lastOp = .dequeue
    super.init(capacity: capacity)
  }

  @inlinable
  init<S: Sequence>(_ elements: S) where S.Element == Element {
    let capacity = _count(elements)
    _capacity = capacity
    _head = 0
    _tail = 0
    _lastOp = .enqueue
    super.init(capacity: capacity)
    self.initialize(from: elements)
  }

  @usableFromInline
  required init(_ _store: _QueueStore) {
    _capacity = _store._capacity
    _head = _store._head
    _tail = _store._tail % _capacity
    _lastOp = _store._lastOp
    super.init(capacity: _store._capacity)
    moveInitialize(from: _store)
  }

  @inlinable
  deinit {
    if _head == _tail {
      if _lastOp == .enqueue {
        deinitialize(range: 0..<_capacity)
      }
    } else if _head < _tail {
      deinitialize(range: _head..<_tail)
    } else {
      deinitialize(range: _head..<_capacity)
      deinitialize(range: 0..<_tail)
    }
  }

  @inlinable
  func moveInitialize(from _store: _QueueStore<Element>) {
    if _store._head == _store._tail {
      if _store._lastOp == .enqueue {
        guard _store._capacity <= _capacity else {
          fatalError("queue is too small")
        }
        _head = 0
        _tail = _store._capacity % _capacity
        _lastOp = .enqueue
        moveInitialize(from: _store, range: 0..<_store._capacity)
      } else {
        _head = 0
        _tail = 0
        _lastOp = .dequeue
      }
      return
    }
    if _store._head < _store._tail {
      guard _store._tail - _store._head <= _capacity else {
        fatalError("queue is too small")
      }
      moveInitialize(from: _store, range: _store._head..<_store._tail, at: 0)
      _head = 0
      _tail = _store._tail - _store._head
    } else {
      let count = _store._tail + _store._capacity - _store._head
      guard count <= _capacity else {
        fatalError("queue is too small")
      }
      moveInitialize(from: _store, range: _store._head..<_store._capacity, at: 0)
      if 0 < _store._tail {
        moveInitialize(from: _store, range: 0..<_store._tail, at: _store._capacity - _store._head)
      }
      _tail = count % _capacity
      _head = 0
      _lastOp = .enqueue
    }
  }

  @usableFromInline
  func set(element: Element, at index: Int) {
    guard let address = _buffer.baseAddress else { fatalError("bad meme") }
    address.advanced(by: index).initialize(to: element)
    _lastOp = .enqueue
  }

  @usableFromInline
  func delete(at index: Int) {
    guard let address = _buffer.baseAddress else { fatalError("bad meme") }
    address.advanced(by: index).deinitialize(count: 1)
    _lastOp = .dequeue
  }
}
