@usableFromInline
protocol _Store<Element>: AnyObject {
  associatedtype Element

  init(_ self: Self)
}

@usableFromInline
protocol _ArrayBasedStore<Element>: _Store {
  associatedtype Element

  var _array: [Element] { get set }
}

@usableFromInline
protocol _LinkBasedStore<Element>: _Store {
  associatedtype Element

  var _link: _LinkStore<Element> { get set }
}
