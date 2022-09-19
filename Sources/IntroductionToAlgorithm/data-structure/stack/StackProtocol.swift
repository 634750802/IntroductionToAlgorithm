public protocol StackProtocol<Element>: DataStructureProtocol, Sequence {

  mutating func push(_ element: Element)
  mutating func pop() -> Element?

  var isEmpty: Bool { get }
}
