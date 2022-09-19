public enum BinaryTreeDir {
  case left
  case right

  var opposite: Self {
    switch self {
      case .left:
        return .right
      case .right:
        return .left
    }
  }
}
