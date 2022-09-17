@usableFromInline
enum _QueueOp {
  case enqueue
  case dequeue
}

@usableFromInline
class _QueueStore<Element>: _Store {

  @usableFromInline
  var _array: ContiguousArray<Element>

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
    _array = .init(unsafeUninitializedCapacity: capacity) { (buffer: inout UnsafeMutableBufferPointer<Element>, initializedCount: inout Int) in initializedCount = capacity }
    _capacity = capacity
    _head = 0
    _tail = 0
    _lastOp = .dequeue
  }

  @usableFromInline
  required init(_ _store: _QueueStore) {
    _array = _store._array
    _capacity = _store._capacity
    _head = _store._head
    _tail = _store._tail
    _lastOp = _store._lastOp
  }

  @usableFromInline
  func set(element: Element, at index: Int) {
    _array.withContiguousMutableStorageIfAvailable { pointer in
      guard let address = pointer.baseAddress else { fatalError("bad meme") }
      address.advanced(by: index).initialize(to: element)
    }
  }

  @usableFromInline
  func delete(at index: Int) {
    _array.withContiguousMutableStorageIfAvailable { pointer in
      guard let address = pointer.baseAddress else { fatalError("bad meme") }
      address.advanced(by: index).deinitialize(count: 1)
    }
  }
}
