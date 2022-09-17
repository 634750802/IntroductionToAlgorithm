@usableFromInline
protocol _LinkPointerHolder<Element> {
  associatedtype Element

  var _next: _LinkPointer<Element>? { get set }
}

@usableFromInline
final class _LinkStore<Element>: _Store, _LinkPointerHolder {

  @usableFromInline
  var _root: _LinkPointer<Element>?

  @usableFromInline
  var _next: _LinkPointer<Element>? {
    get { _root }
    set { _root = newValue }
  }

  @usableFromInline
  init() {
    _root = nil
  }

  @inlinable
  required init(_ link: _LinkStore<Element>) {
    _root = _link_node_clone(node: link._root)
  }

  @inlinable
  deinit {
    _link_node_dealloc(node: _root)
  }

  @inlinable
  func node(at: Int) -> _LinkPointer<Element>? {
    guard at >= 0 else { return nil }
    var at = at
    var p = _root
    while at > 0 {
      if let n = p?.pointee._next {
        p = n
      }
      at -= 1
    }
    return p
  }

  @inlinable
  func insert(_ element: Element, at index: Int) {
    if index == 0 {
      var _self = self
      _link_node_insert_after(node: &_self, element: element)
    } else if let ptr = node(at: index - 1) {
      _link_node_insert_after(node: &ptr.pointee, element: element)
    } else {
      fatalError("bad link node index")
    }
  }

  @inlinable
  func delete(at index: Int) {
    if index == 0 {
      var _self = self
      _link_node_delete_next(node: &_self)
    } else if let ptr = node(at: index - 1) {
      _link_node_delete_next(node: &ptr.pointee)
    } else {
      fatalError("bad link node index")
    }
  }
}

extension _LinkStore: Sequence {
  public func makeIterator() -> LinkNodeIterator<Element> {
    LinkNodeIterator(_root)
  }
}

@usableFromInline
@frozen struct _LinkNode<Element>: _LinkPointerHolder {

  @usableFromInline
  var _element: Element

  @usableFromInline
  var _next: _LinkPointer<Element>?

  @usableFromInline
  init(element: Element, next: _LinkPointer<Element>?) {
    _element = element
    _next = next
  }
}

@usableFromInline
typealias _LinkPointer<T> = UnsafeMutablePointer<_LinkNode<T>>

@inlinable
func _link_node_clone<T>(node: _LinkPointer<T>?) -> _LinkPointer<T>? {
  var iter = LinkNodeIterator(node)

  var parent: _LinkPointer<T>?
  var newRoot: _LinkPointer<T>?

  while let e = iter.next() {
    let ptr = _LinkPointer<T>.allocate(capacity: 1)
    _debug_link_allocate_record()
    ptr.initialize(to: .init(element: e, next: nil))
    if let parent {
      parent.pointee._next = ptr
    } else {
      newRoot = ptr
    }
    parent = ptr
  }


  return newRoot
}

@inlinable
func _link_node_dealloc<T>(node: _LinkPointer<T>?) {
  var current = node
  while let c = current {
    current = c.pointee._next
    c.deinitialize(count: 1)
    c.deallocate()
    _debug_link_deallocate_record()
  }
}

@discardableResult
@inlinable
func _link_node_insert_after<T>(node: inout some _LinkPointerHolder<T>, element: T) -> _LinkPointer<T> {
  let ptr = _LinkPointer<T>.allocate(capacity: 1)
  _debug_link_allocate_record()
  ptr.initialize(to: .init(element: element, next: node._next))
  node._next = ptr
  return ptr
}

@inlinable
func _link_node_delete_next<T>(node: inout some _LinkPointerHolder<T>) {
  if let ptr = node._next {
    node._next = ptr.pointee._next
    ptr.deinitialize(count: 1)
    ptr.deallocate()
    _debug_link_deallocate_record()

  }
}

@usableFromInline
var _debug_link_node_count = 0

#if DEBUG
  @inlinable
  func _debug_link_allocate_record() {
    _debug_link_node_count += 1
  }

  @inlinable
  func _debug_link_deallocate_record() {
    _debug_link_node_count -= 1
  }
#else
  @inlinable
  func _debug_link_allocate_record() {
  }

  @inlinable
  func _debug_link_deallocate_record() {
  }
#endif