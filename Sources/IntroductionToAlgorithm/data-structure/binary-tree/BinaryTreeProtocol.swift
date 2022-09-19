
public protocol BinaryTreeProtocol<Element> {
  associatedtype Element

  mutating func remove<S: Sequence>(path: S) where S.Element == BinaryTreeDir
  mutating func insert<S: Sequence>(path: S, element: Element) where S.Element == BinaryTreeDir
  mutating func mutate<S: Sequence>(path: S, by: (inout Element) -> Void) where S.Element == BinaryTreeDir
}
