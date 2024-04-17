import gleam/list

pub type NestedList(a) {
  Null
  Value(a)
  List(List(NestedList(a)))
}

fn flatten_tail(nested_list: NestedList(a), acc: List(a)) -> List(a) {
  case nested_list {
    Null -> acc
    Value(x) -> list.append(acc, [x])
    List(x) -> list.fold(x, acc, fn(y, z) { flatten_tail(z, y) })
  }
}

pub fn flatten(nested_list: NestedList(a)) -> List(a) {
  flatten_tail(nested_list, [])
}
