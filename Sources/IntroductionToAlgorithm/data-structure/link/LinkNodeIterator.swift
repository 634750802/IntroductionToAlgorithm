@usableFromInline
struct LinkNodeIterator<Element>: IteratorProtocol {
  @usableFromInline
  var _current: _LinkPointer<Element>?

  @usableFromInline
  init(_ current: _LinkPointer<Element>?) {
    _current = current
  }

  @usableFromInline
  mutating func next() -> Element? {
    guard let current = _current else { return nil }
    defer {
      _current = current.pointee._next
    }
    return current.pointee._element
  }
}
