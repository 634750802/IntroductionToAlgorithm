@usableFromInline
internal protocol _ArrayStoredProtocol: _StoredProtocol where Store: _ArrayBasedStore, Store.Element == Self.Element {

}

extension _ArrayStoredProtocol {
  public typealias Iterator = Array<Element>.Iterator

  @inlinable
  public func makeIterator() -> Iterator {
    _store._array.makeIterator()
  }
}
