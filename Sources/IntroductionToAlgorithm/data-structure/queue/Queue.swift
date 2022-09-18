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
    let capacity = _count(elements)
    let store = _QueueStore<Element>(capacity: capacity)
    var iter = elements.makeIterator()
    var i = 0
    while let element = iter.next() {
      store.set(element: element, at: i)
      i += 1
    }
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
