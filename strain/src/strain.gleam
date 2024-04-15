pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  case list {
    [x, ..rest] -> {
      case predicate(x) {
        True -> [x, ..keep(rest, predicate)]
        False -> keep(rest, predicate)
      }
    }
    [] -> []
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(t) { predicate(t) == False })
}
