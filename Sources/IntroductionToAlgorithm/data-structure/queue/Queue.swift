public struct Queue<Element>: _QueueProtocol {
  public typealias Element = Element

  @usableFromInline
  var _store: _QueueStore<Element>

  @inlinable
  init(_store: _QueueStore<Element>) {
    self._store = _store
  }

  public init() {
    self.init(capacity: 32)
  }

  public init(capacity: Int) {
    self.init(_store: .init(capacity: capacity))
  }

  public init<S: Sequence>(_ elements: S) where S.Element == Element {
    let store = _QueueStore<Element>(elements)
    self.init(_store: store)
  }
}

@inlinable
func _count(_ sequence: some Sequence) -> Int {
  var cnt = 0
  var iter = sequence.makeIterator()
  while iter.next() != nil {
    cnt += 1
  }
  return cnt
}
