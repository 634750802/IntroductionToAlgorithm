@usableFromInline
protocol _HeapProtocol<Element>: _ArrayStoredProtocol, HeapProtocol where Store == _HeapStore<Element> {
  associatedtype Element

  init(_store: Store)

  func _compare(_ l: Element, _ r: Element) -> Bool
}

extension _HeapProtocol {
  @inlinable
  mutating func _heapify(_ i: Int) {
    var i = i
    var l, r, largest: Int
    while true {
      l = _heap_left(i)
      r = _heap_right(i)
      if l < _store._size && _compare(self[l], self[i]) {
        largest = l
      } else {
        largest = i
      }
      if r < _store._size && _compare(self[r], self[largest]) {
        largest = r
      }
      if largest != i {
        _store._array.swapAt(i, largest)
        i = largest
      } else {
        break
      }
    }
  }

  @inlinable
  subscript(index: Int) -> Element {
    _store._array[index]
  }
}

// Sequence

extension _HeapProtocol {

}

// HeapProtocol

extension _HeapProtocol {

  @inlinable
  public init() {
    self.init(_store: .init())
  }

  @inlinable
  public init<S: Sequence>(_ sequence: S) where S.Element == Element {
    self.init(_store: .init(sequence))
    for i in (0..<_store._size / 2).reversed() {
      _heapify(i)
    }
  }

  @inlinable
  public mutating func insert(_ element: Element) {
    _cloneIfNeeds()
    _store._array.append(element)
    var i = _store._size
    while i > 0 {
      let p = _heap_parent(i)
      if _compare(self[p], self[i]) {
        break
      }
      _store._array.swapAt(i, p)
      i = p
    }
    _store._size += 1
  }

  @inlinable
  public mutating func pop() -> Element? {
    _cloneIfNeeds()
    guard _store._size > 0 else {
      return nil
    }
    _store._size -= 1
    _store._array.swapAt(0, _store._size)
    _heapify(0)
    return _store._array.popLast()
  }
}

extension _HeapProtocol {
  var prettyDescription: String {
    var res = ""
    var i = 0
    var r = 0
    var f = false
    while i < _store._size {
      if i + 1 == 1 << r {
        res += "\n"
        r += 1
      }
      res += "(\(i)):\(self[i])"
      if f {
        res += " "
      } else {
        f = true
      }

      i += 1
    }
    return res
  }
}