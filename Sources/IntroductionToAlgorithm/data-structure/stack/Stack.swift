public struct Stack<Element>: _StackProtocol {
  public typealias Element = Element

  @usableFromInline
  var _store: _StackStore<Element>

  @inlinable
  init(_store: _StackStore<Element>) {
    self._store = _store
  }

  @inlinable
  public mutating func push(_ element: Element) {
    _cloneIfNeeds()
    _store._array.append(element)
  }

  @discardableResult
  @inlinable
  public mutating func pop() -> Element? {
    _cloneIfNeeds()
    return _store._array.popLast()
  }

  @inlinable
  public var isEmpty: Bool {
    _store._array.isEmpty
  }
}