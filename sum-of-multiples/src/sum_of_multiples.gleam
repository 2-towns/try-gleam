import gleam/list
import gleam/result

fn is_multiple(number: Int, factors: List(Int)) {
  let first = result.unwrap(list.first(factors), 0)
  let calculation = number % first
  case factors {
    _ if first == 0 -> False
    _ if calculation == 0 -> True
    [_, ..rest] -> is_multiple(number, rest)
    [] -> False
  }
}

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.range(0, limit - 1)
  |> list.filter(is_multiple(_, factors))
  |> list.fold(0, fn(count, e) { count + e })
}
