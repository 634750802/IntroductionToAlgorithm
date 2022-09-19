@usableFromInline
internal class _UnsafeListStore<Element> {

  @usableFromInline
  var _buffer: UnsafeMutableBufferPointer<Element>

  @inlinable
  init(capacity: Int) {
    _buffer = .allocate(capacity: capacity)
  }

  @inlinable
  deinit {
    _buffer.deallocate()
  }

  @inlinable
  func pointer(at index: Int) -> UnsafeMutablePointer<Element> {
    guard let baseAddress = _buffer.baseAddress, _buffer.indices.contains(index) else { fatalError("index out of range") }
    return baseAddress.advanced(by: index)
  }

  @inlinable
  func initialize(element: Element, at index: Int) {
    pointer(at: index).initialize(to: element)
  }

  @inlinable
  func initialize<S: Sequence>(from elements: S, at index: Int = 0) where S.Element == Element {
    var i  = 0
    let pointer = pointer(at: index)
    var iter = elements.makeIterator()
    while i < _buffer.endIndex, let element = iter.next() {
      pointer.advanced(by: i).initialize(to: element)
      i += 1
    }
  }

  @inlinable
  func deinitialize(at index: Int) {
    deinitialize(range: index..<index+1)
  }

  @inlinable
  func deinitialize(range: Range<Int>) {
    pointer(at: range.startIndex).deinitialize(count: range.count)
  }

  @inlinable
  func assign(element: Element, at index: Int) {
    let ptr = pointer(at: index)
    ptr.pointee = element
  }

  @inlinable
  func move(at index: Int) -> Element {
    pointer(at: index).move()
  }

  @inlinable
  func moveInitialize(from: UnsafeMutablePointer<Element>, index: Int = 0, at: Int = 0) {
    moveInitialize(from: from, range: index..<index + 1, at: at)
  }

  @inlinable
  func moveInitialize(from: UnsafeMutablePointer<Element>, range: Range<Int>, at index: Int = 0) {
    pointer(at: index).moveInitialize(from: from.advanced(by: range.startIndex), count: range.count)
  }

  @inlinable
  func moveInitialize(from: _UnsafeListStore<Element>, range: Range<Int>, at index: Int = 0) {
    moveInitialize(from: from.pointer(at: 0), range: range, at: index)
  }

  @inlinable
  func moveAssign(from: UnsafeMutablePointer<Element>, index: Int = 0, at: Int = 0) {
    moveAssign(from: from, range: index..<index + 1, at: at)
  }

  @inlinable
  func moveAssign(from: UnsafeMutablePointer<Element>, range: Range<Int>, at index: Int = 0) {
    let ptr = pointer(at: index)
    ptr.moveAssign(from: from, count: range.count)
  }
}