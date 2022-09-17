public protocol DataStructureProtocol<Element> {
  associatedtype Element

  init()
  init<S: Sequence>(_ elements: S) where S.Element == Element
}