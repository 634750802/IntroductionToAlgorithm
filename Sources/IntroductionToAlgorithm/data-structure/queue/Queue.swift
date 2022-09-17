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
    let arr = ContiguousArray(elements)
    let store = _QueueStore<Element>.init(capacity: arr.count)
    store._array = arr
    store._tail = arr.endIndex
    self.init(_store: store)
  }
}
