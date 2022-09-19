public struct BinaryTree<Element>: BinaryTreeProtocol, _StoredProtocol {

  @usableFromInline
  var _store: _BinaryTreeStore<Element>

  public init() {
    _store = .init()
  }

  @usableFromInline
  init(root: _BinaryTreePointer<Element>) {
    _store = .init(root: root)
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
  mutating func _insert<S>(path: S, node: (_BinaryTreePointer<Element>?) -> _BinaryTreePointer<Element>?) where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    let (parent, path) = _find(parent: path)
    guard let path else {
      guard _store._root == nil else { fatalError("bad insert: leaf already exists") }
      _store._root = node(parent)
      return
    }
    guard let parent else {
      fatalError("bad insert: root not exists")
    }
    parent.pointee[path] = node(parent)
  }

  @discardableResult
  @inlinable
  public mutating func remove<S>(path: S) -> Self where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    let ptr = _find(path: path)
    if let ptr {
      if let parent = ptr.pointee._p {
        if parent.pointee._l == ptr {
          parent.pointee._l = nil
          return BinaryTree(root: ptr)
        } else if parent.pointee._r == ptr {
          parent.pointee._r = nil
          return BinaryTree(root: ptr)
        } else {
          fatalError("bad tree")
        }
      } else {
        guard _store._root == ptr else { fatalError("bad tree") }
        _store._root = nil
        return BinaryTree(root: ptr)
      }
    } else {
      fatalError("bad tree: no root")
    }
  }

  @inlinable
  public mutating func insert<S>(path: S, element: Element) where S: Sequence, S.Element == BinaryTreeDir {
    _insert(path: path) { parent in _binary_tree_node_allocate(element: element, parent: parent) }
  }

  @inlinable
  public mutating func insert<S>(path: S, tree: inout BinaryTree<Element>) where S: Sequence, S.Element == BinaryTreeDir {
    _insert(path: path) { parent in
      tree._cloneIfNeeds()
      let pointer = tree._store._root
      pointer?.pointee._p = parent
      tree._store._root = nil
      return pointer
    }
  }

  @inlinable
  public mutating func mutate<S>(path: S, by mutating: (inout Element) -> Void) where S: Sequence, S.Element == BinaryTreeDir {
    _cloneIfNeeds()
    guard let ptr = _find(path: path) else { fatalError("bad tree path") }
    mutating(&ptr.pointee._element)
  }

  public var depth: Int {
    _binary_tree_depth(node: _store._root)
  }
}

extension BinaryTree: Sequence {

  public struct BFView<Element>: BinaryTreeView {
    @usableFromInline
    var _tree: BinaryTree<Element>

    @usableFromInline
    init(_ tree: BinaryTree<Element>) { _tree = tree }

    public func makeIterator() -> BinaryTreeBreadthFirstIterator<Element> {
      BinaryTreeBreadthFirstIterator(_tree._store._root)
    }
  }

  public struct DFView<Element>: BinaryTreeView {
    @usableFromInline
    var _tree: BinaryTree<Element>

    @usableFromInline
    init(_ tree: BinaryTree<Element>) { _tree = tree }

    public func makeIterator() -> BinaryTreeDepthFirstIterator<Element> {
      BinaryTreeDepthFirstIterator(_tree._store._root)
    }
  }

  public func makeIterator() -> BinaryTreeDepthFirstIterator<Element> {
    BinaryTreeDepthFirstIterator(_store._root)
  }

  public var bfView: BFView<Element> {
    BFView(self)
  }

  public var dfView: DFView<Element> {
    DFView(self)
  }
}
