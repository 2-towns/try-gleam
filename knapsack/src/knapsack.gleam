import gleam/list
import gleam/order
import gleam/result

pub type Item {
  Item(value: Int, weight: Int)
}

fn calculate_value(items: List(Item), acc: Int) {
  case items {
    [x, ..rest] -> calculate_value(rest, acc + x.value)
    [] -> acc
  }
}

fn sort(a: List(Item), b: List(Item)) {
  case calculate_value(a, 0), calculate_value(b, 0) {
    x, y if x == y -> order.Eq
    x, y if x > y -> order.Lt
    _, _ -> order.Gt
  }
}

fn is_weight_valid(items: List(Item), maximum_weight: Int, acc: Int) {
  case items {
    [x, ..rest] -> {
      let value = acc + x.weight
      case value {
        v if v <= maximum_weight ->
          is_weight_valid(rest, maximum_weight, acc + x.weight)
        _ -> False
      }
    }
    [] -> True
  }
}

fn combinations(items: List(Item), size: Int) {
  case size {
    x if x > 0 ->
      list.append(list.combinations(items, size), combinations(items, size - 1))
    _ -> []
  }
}

pub fn maximum_value(items: List(Item), maximum_weight: Int) -> Int {
  combinations(items, list.length(items))
  |> list.filter(fn(x) { is_weight_valid(x, maximum_weight, 0) })
  |> list.sort(sort)
  |> list.first
  |> result.unwrap([])
  |> calculate_value(0)
}
