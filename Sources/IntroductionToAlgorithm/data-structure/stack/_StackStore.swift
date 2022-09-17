@usableFromInline
final class _StackStore<Element>: _ArrayBasedStore {
  @usableFromInline
  var _array: [Element] = []

  @inlinable
  init(_ self: _StackStore<Element>) {
    _array = self._array
  }

  @usableFromInline
  init() {}

  @usableFromInline
  init<S: Sequence>(_ elements: S) where S.Element == Element {
    _array = .init(elements)
  }
}
