import gleam/int
import gleam/list

const digits = [1, 2, 3, 4, 5, 6, 7, 8, 9]

pub fn combinations(
  size size: Int,
  sum sum: Int,
  exclude exclude: List(Int),
) -> List(List(Int)) {
  list.filter(digits, fn(x) { list.contains(exclude, x) == False })
  |> list.combinations(size)
  |> list.filter(fn(x) { int.sum(x) == sum })
}
