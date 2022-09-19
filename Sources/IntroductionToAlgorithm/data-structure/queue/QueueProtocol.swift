public protocol QueueProtocol<Element>: DataStructureProtocol {
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  mutating func resize(capacity: Int)
  mutating func increaseSizeIfNeed(factor: Float)

  var isFull: Bool { get }
  var isEmpty: Bool { get }
  var count: Int { get }
}
