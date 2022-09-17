@usableFromInline
protocol _StackProtocol<Element>: _ArrayStoredProtocol, StackProtocol where Store == _StackStore<Element> {
  associatedtype Element

  init(_store: Store)
}

extension _StackProtocol {
  public init() {
    self.init(_store: .init())
  }

  public init<S: Sequence>(_ elements: S) where S.Element == Element {
    self.init(_store: .init(elements))
  }
}