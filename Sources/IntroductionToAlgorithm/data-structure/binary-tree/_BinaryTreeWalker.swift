public enum _TreeWalkerState<State> {
  case next(State)
  case stop(State)
  case interrupt(State)
}

@usableFromInline
typealias _BinaryTreeWalker<Element, State> = (_BinaryTreePointer<Element>, State) -> _TreeWalkerState<State>

