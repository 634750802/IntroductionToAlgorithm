public protocol HeapProtocol<Element>: DataStructureProtocol, Sequence {

  mutating func insert(_ element: Element)
}
