public struct MaxHeap<Element: Comparable>: _HeapProtocol {
  public typealias Element = Element
  public typealias Iterator = Array<Element>.Iterator

  @usableFromInline
  var _store: _HeapStore<Element>

  @inlinable
  init(_store: _HeapStore<Element>) { self._store = _store }

  @inlinable
  func _compare(_ l: Element, _ r: Element) -> Bool {
    l >= r
  }
}

public struct MinHeap<Element: Comparable>: _HeapProtocol {
  public typealias Element = Element
  public typealias Iterator = Array<Element>.Iterator

  @usableFromInline
  var _store: _HeapStore<Element>

  @inlinable
  init(_store: _HeapStore<Element>) {
    self._store = _store
  }

  @inlinable
  func _compare(_ l: Element, _ r: Element) -> Bool {
    l <= r
  }
}
