public enum BinaryTreeDir {
  case left
  case right

  public var opposite: Self {
    switch self {
      case .left:
        return .right
      case .right:
        return .left
    }
  }
}
