public protocol QueueProtocol<Element>: DataStructureProtocol {
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isFull: Bool { get }
  var isEmpty: Bool { get }
}
