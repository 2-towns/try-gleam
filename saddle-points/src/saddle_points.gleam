import gleam/dict
import gleam/int
import gleam/list
import gleam/result

pub type Position {
  Position(row: Int, column: Int)
}

pub fn saddle_points(matrix: List(List(Int))) -> List(Position) {
  let min_per_columns =
    list.index_fold(matrix, dict.new(), fn(acc, row, _) {
      list.index_fold(row, acc, fn(acc, column, column_index) {
        dict.get(acc, column_index)
        |> result.unwrap(column)
        |> fn(x) { dict.insert(acc, column_index, int.min(x, column)) }
      })
    })

  list.index_map(matrix, fn(row, row_index) {
    let max_per_row =
      list.sort(row, int.compare)
      |> list.reverse
      |> list.first
      |> result.unwrap(0)

    list.index_fold(row, [], fn(acc, column, column_index) {
      let min_per_column =
        dict.get(min_per_columns, column_index)
        |> result.unwrap(column)
      case column == max_per_row && column == min_per_column {
        True -> list.append(acc, [Position(row_index + 1, column_index + 1)])
        False -> acc
      }
    })
  })
  |> list.flatten
}
