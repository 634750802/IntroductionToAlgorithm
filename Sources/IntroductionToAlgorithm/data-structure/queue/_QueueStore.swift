@usableFromInline
enum _QueueOp {
  case enqueue
  case dequeue
}

@usableFromInline
class _QueueStore<Element>: _Store {

  @usableFromInline
  var _buffer: UnsafeMutableBufferPointer<Element>

  @usableFromInline
  let _capacity: Int

  @usableFromInline
  var _head: Int

  @usableFromInline
  var _tail: Int

  @usableFromInline
  var _lastOp: _QueueOp

  @usableFromInline
  init(capacity: Int) {
    _buffer = .allocate(capacity: capacity)
    _capacity = capacity
    _head = 0
    _tail = 0
    _lastOp = .dequeue
  }

  @usableFromInline
  required init(_ _store: _QueueStore) {
    _buffer = .allocate(capacity: _store._capacity)
    var iter = QueueIterator(_store)
    var i = 0
    while let element = iter.next() {
      _buffer.baseAddress!.advanced(by: i).initialize(to: element)
      i += 1
    }
    _capacity = _store._capacity
    _head = _store._head
    _tail = _store._tail
    _lastOp = _store._lastOp
  }

  deinit {
    var current = _head
    if current == _tail && _lastOp == .dequeue {
      _buffer.deallocate()
      return
    }
    repeat {
      delete(at: current)
      current = (current + 1) % _capacity
    } while current != _tail
    _buffer.deallocate()
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
