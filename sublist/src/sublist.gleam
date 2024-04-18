import gleam/list

pub type Comparison {
  Equal
  Unequal
  Sublist
  Superlist
}

fn extract_sublist(list_a: List(a), item: a) {
  case list_a {
    [x, ..rest] if x == item -> rest
    [_, ..rest] -> extract_sublist(rest, item)
    _ -> []
  }
}

fn is_superlist(list_a: List(a), list_b: List(a)) {
  case list_b {
    x if x == list_a -> True
    [x, ..rest] -> {
      let sub = extract_sublist(list_a, x)
      case list.length(sub), list.length(list_b) {
        0, x if x != 0 -> False
        _, _ -> is_superlist(sub, rest)
      }
    }
    _ -> True
  }
}

pub fn sublist(compare list_a: List(a), to list_b: List(a)) -> Comparison {
  case
    list_a,
    list_b,
    is_superlist(list_a, list_b),
    is_superlist(list_b, list_a)
  {
    x, y, _, _ if x == y -> Equal
    _, _, True, _ -> Superlist
    _, _, _, True -> Sublist
    _, _, _, _ -> Unequal
  }
}
