@usableFromInline
protocol _BinaryTreeProtocol<Element>: BinaryTreeProtocol, _StoredProtocol where Store == _BinaryTreeStore<Element> {
  associatedtype Element
}
