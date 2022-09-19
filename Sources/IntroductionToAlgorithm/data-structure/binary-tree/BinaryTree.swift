public struct BinaryTree<Element>: BinaryTreeProtocol, _StoredProtocol {

  @usableFromInline
  var _store: _BinaryTreeStore<Element>

  public init() {
    _store = .init()
  }

  @inlinable
  func _find<S>(path: S) -> _BinaryTreePointer<Element>? where S: Sequence, S.Element == BinaryTreeDir {
    var iter = path.makeIterator()
    var node = _store._root
    while let path = iter.next(), let current = node {
      node = current.pointee[path]
    }

    return node
  }

  @inlinable
  func _find<S>(parent path: S) -> (_BinaryTreePointer<Element>?, BinaryTreeDir?) where S: Sequence, S.Element == BinaryTreeDir {
    var iter = path.makeIterator()
    var parent: _BinaryTreePointer<Element>?
    var lastPath: BinaryTreeDir?
    var node = _store._root
    while let path = iter.next(), let current = node {
      parent = node
      node = current.pointee[path]
      lastPath = path
    }

    return (parent, lastPath)
  }

  @inlinable
  public mutating func remove<S>(path: S) where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    let ptr = _find(path: path)
    if let ptr {
      if let parent = ptr.pointee._p {
        if parent.pointee._l == ptr {
          parent.pointee._l = nil
          _binary_tree_node_dealloc(node: ptr)
        } else if parent.pointee._r == ptr {
          parent.pointee._r = nil
          _binary_tree_node_dealloc(node: ptr)
        } else {
          fatalError("bad tree")
        }
      } else {
        guard _store._root == ptr else { fatalError("bad tree") }
        _store._root = nil
        _binary_tree_node_dealloc(node: ptr)
      }
    } else {
      fatalError("bad tree: no root")
    }
  }

  @inlinable
  public mutating func insert<S>(path: S, element: Element) where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    let (parent, path) = _find(parent: path)
    let node = _BinaryTreePointer<Element>.allocate(capacity: 1)
    node.initialize(to: .init(_p: parent, _l: nil, _r: nil, _element: element))
    guard let path else {
      guard _store._root == nil else { fatalError("bad insert: leaf already exists") }
      _store._root = node
      return
    }
    guard let parent else {
      fatalError("bad insert: root not exists")
    }
    parent.pointee[path] = node
  }

  @inlinable
  public mutating func mutate<S>(path: S, by mutating: (inout Element) -> Void) where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    guard let ptr = _find(path: path) else { fatalError("bad tree path") }
    mutating(&ptr.pointee._element)
  }
}