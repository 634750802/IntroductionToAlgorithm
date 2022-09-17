@usableFromInline
internal protocol _LinkStoredProtocol: _StoredProtocol where Store: _LinkBasedStore, Store.Element == Self.Element {

}

extension _LinkStoredProtocol {
  public typealias Iterator = LinkNodeIterator<Element>

  @inlinable
  public func makeIterator() -> Iterator {
    _store._link.makeIterator()
  }
}
