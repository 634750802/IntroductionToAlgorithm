@usableFromInline
final class _HeapStore<Element>: _ArrayBasedStore {
  @usableFromInline
  var _array: [Element] = []

  @usableFromInline
  var _size: Int = 0

  @usableFromInline
  init() {}

  @usableFromInline
  init<S: Sequence>(_ elements: S) where S.Element == Element {
    _array = .init(elements)
    _size = _array.count
  }

  @usableFromInline
  init(_ store: _HeapStore<Element>) {
    _array = store._array
    _size = store._size
  }
}

@inlinable
func _heap_parent(_ i: Int) -> Int {
  (i + 1) / 2 - 1
}

@inlinable
func _heap_left(_ i: Int) -> Int {
  i * 2 + 1
}

@inlinable
func _heap_right(_ i: Int) -> Int {
  i * 2 + 2
}
