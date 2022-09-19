@usableFromInline
class _BinaryTreeStore<Element>: _Store {
  @usableFromInline
  typealias Element = Element

  @usableFromInline
  var _root: _BinaryTreePointer<Element>?

  @inlinable
  required init(_ store: _BinaryTreeStore<Element>) {
    _root = _binary_tree_node_clone(node: store._root)
  }

  @inlinable
  init() {
    _root = nil
  }

  deinit {
    _binary_tree_node_dealloc(node: _root)
  }
}

@usableFromInline
struct _BinaryTreeNode<Element> {
  @usableFromInline
  var _p: _BinaryTreePointer<Element>?

  @usableFromInline
  var _l: _BinaryTreePointer<Element>?

  @usableFromInline
  var _r: _BinaryTreePointer<Element>?

  @usableFromInline
  var _element: Element

  @usableFromInline
  init(_p: _BinaryTreePointer<Element>? = nil, _l: _BinaryTreePointer<Element>? = nil, _r: _BinaryTreePointer<Element>? = nil, _element: Element) {
    self._p = _p
    self._l = _l
    self._r = _r
    self._element = _element
  }

  @inlinable
  subscript(dir: BinaryTreeDir) -> _BinaryTreePointer<Element>? {
    get {
      switch dir {
        case .left:
          return _l
        case .right:
          return _r
      }
    }
    set {
      switch dir {
        case .left:
          _l = newValue
        case .right:
          _r = newValue
      }
    }
  }
}

@usableFromInline
typealias _BinaryTreePointer<Element> = UnsafeMutablePointer<_BinaryTreeNode<Element>>

@usableFromInline
func _binary_tree_node_allocate<T>(element: T, parent: _BinaryTreePointer<T>?) -> _BinaryTreePointer<T> {
  let ptr = _BinaryTreePointer<T>.allocate(capacity: 1)
  ptr.initialize(to: .init(_p: parent, _l: nil, _r: nil, _element: element))
  _debug_binary_tree_allocate_record()
  return ptr
}

@usableFromInline
func _binary_tree_node_dealloc<T>(node: _BinaryTreePointer<T>?) {
  guard let node else { return }
  _binary_tree_node_walk_bf(node: node, initialState: ()) { (pointer, _) in
    pointer.deinitialize(count: 1)
    pointer.deallocate()
    _debug_binary_tree_deallocate_record()
    return .next(())
  }
}

@usableFromInline
func _binary_tree_node_clone<T>(node: _BinaryTreePointer<T>?) -> _BinaryTreePointer<T>? {
  guard let node else { return nil }

  let new = _binary_tree_node_allocate(element: node.pointee._element, parent: node.pointee._p)

  if let l = node.pointee._l {
    new.pointee._l = _binary_tree_node_clone(node: l)
  }

  if let r = node.pointee._r {
    new.pointee._r = _binary_tree_node_clone(node: r)
  }

  return new
}

@usableFromInline
func _binary_tree_node_walk_bf<T, S>(node: _BinaryTreePointer<T>, initialState: S, walker: _BinaryTreeWalker<T, S>) -> S {
  var queue = Queue<_BinaryTreePointer<T>>(capacity: 8)
  var state = initialState
  queue.enqueue(node)
  loop: while let node = queue.dequeue() {
    let l = node.pointee._l
    let r = node.pointee._r
    switch walker(node, state) {
      case .next(let s):
        state = s
      case .stop(let s):
        state = s
        continue loop
      case .interrupt(let s):
        state = s
        break loop
    }
    if let l {
      queue.increaseSizeIfNeed(factor: 2)
      queue.enqueue(l)
    }
    if let r {
      queue.increaseSizeIfNeed(factor: 2)
      queue.enqueue(r)
    }
  }
  return state
}

@usableFromInline
func _binary_tree_node_walk_df<T, S>(node: _BinaryTreePointer<T>, initialState: S, walker: _BinaryTreeWalker<T, S>) -> S {
  var stack = Stack<_BinaryTreePointer<T>>()
  var state = initialState
  stack.push(node)
  loop: while let node = stack.pop() {
    let l = node.pointee._l
    let r = node.pointee._r
    switch walker(node, state) {
      case .next(let s):
        state = s
      case .stop(let s):
        state = s
        continue loop
      case .interrupt(let s):
        state = s
        break loop
    }
    if let r {
      stack.push(r)
    }
    if let l {
      stack.push(l)
    }
  }
  return state
}


@usableFromInline
var _debug_binary_tree_node_count = 0

#if DEBUG || RELEASE_TEST
  @inlinable
  func _debug_binary_tree_allocate_record() {
    _debug_binary_tree_node_count += 1
  }

  @inlinable
  func _debug_binary_tree_deallocate_record() {
    _debug_binary_tree_node_count -= 1
  }
#else
  @inlinable
  func _debug_binary_tree_allocate_record() {
  }

  @inlinable
  func _debug_binary_tree_deallocate_record() {
  }
#endif