public protocol BinarySearchTreeProtocol<Element>: BinaryTreeProtocol where Key: Comparable {
  associatedtype Key

  static var key: KeyPath<Element, Key> { get }

  mutating func find(key: Key) -> Element?
  mutating func add(value: Element)
}
