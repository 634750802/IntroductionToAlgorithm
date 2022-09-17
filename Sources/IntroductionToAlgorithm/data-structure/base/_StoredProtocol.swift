@usableFromInline
internal protocol _StoredProtocol<Element> {
  associatedtype Element
  associatedtype Store: _Store where Element == Self.Element

  var _store: Store { get set }
  mutating func _cloneIfNeeds()
}

extension _StoredProtocol {
  @inlinable
  mutating func _cloneIfNeeds() {
    if !isKnownUniquelyReferenced(&_store) {
      _store = .init(_store)
    }
  }
}
