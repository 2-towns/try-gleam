import gleam/list

fn factors_tail(value: Int, factor: Int, acc: List(Int)) {
  case value % factor {
    x if x == value -> acc
    0 -> factors_tail(value / factor, factor, list.append(acc, [factor]))
    _ -> factors_tail(value, factor + 1, acc)
  }
}

pub fn factors(value: Int) -> List(Int) {
  factors_tail(value, 2, [])
}
