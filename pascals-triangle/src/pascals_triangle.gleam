import gleam/list
import gleam/result

fn calculate_row(list: List(Int), acc: List(Int)) {
  case list, list.length(acc) {
    _, 0 -> calculate_row(list, [1])
    [x, y, ..previous], _ ->
      calculate_row(list.append([y], previous), list.append(acc, [x + y]))
    [], _ -> list.append(acc, [1])
    [_], _ -> list.append(acc, [1])
  }
}

fn rows_tails(n: Int, acc: List(List(Int))) {
  case n, list.length(acc) {
    0, _ -> []
    1, _ -> [[1]]
    n, 0 -> rows_tails(n, [[1]])
    n, 1 -> rows_tails(n, list.append(acc, [[1, 1]]))
    n, len if len < n ->
      rows_tails(
        n,
        list.append(
          acc,
          list.last(acc)
            |> result.unwrap([])
            |> fn(x) { [calculate_row(x, [])] },
        ),
      )
    _, _ -> acc
  }
}

pub fn rows(n: Int) -> List(List(Int)) {
  rows_tails(n, [])
}
