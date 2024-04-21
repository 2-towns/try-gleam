import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Position =
  #(Int, Int)

type Board =
  Dict(Position, String)

fn cell_value(value: String, around: List(String)) {
  case value {
    "*" -> "*"
    _ ->
      list.filter(around, fn(x) { x != "_" && x != " " })
      |> list.length
      |> int.to_string
      |> string.replace("0", "_")
  }
}

fn safe_value(board: Board, position: Position) {
  dict.get(board, position)
  |> result.unwrap(" ")
}

fn around_cell(board: Board, position: Position) {
  {
    safe_value(board, #(position.0 - 1, position.1 - 1))
    <> safe_value(board, #(position.0, position.1 - 1))
    <> safe_value(board, #(position.0 + 1, position.1 - 1))
    <> safe_value(board, #(position.0 - 1, position.1))
    <> safe_value(board, #(position.0 + 1, position.1))
    <> safe_value(board, #(position.0 - 1, position.1 + 1))
    <> safe_value(board, #(position.0, position.1 + 1))
    <> safe_value(board, #(position.0 + 1, position.1 + 1))
  }
  |> string.to_graphemes
}

fn calculate_mines(board: Board, position: #(Int, Int)) {
  case dict.get(board, position), around_cell(board, position) {
    // Right 
    Ok(cell), [top_left, top, " ", left, " ", bottom_left, bottom, " "] ->
      cell_value(cell, [top_left, top, left, bottom_left, bottom])
      <> "\n"
      <> calculate_mines(board, #(0, position.1 + 1))

    // Left 
    Ok(cell), x ->
      cell_value(cell, x)
      <> calculate_mines(board, #(position.0 + 1, position.1))

    Error(_), _ -> ""
  }
}

fn to_board(minefield: String) {
  string.split(minefield, "\n")
  |> list.index_fold(dict.new(), fn(board, row, row_index) {
    list.index_fold(
      string.to_graphemes(row),
      board,
      fn(acc, cell, column_index) {
        dict.insert(acc, #(column_index, row_index), cell)
      },
    )
  })
}

pub fn annotate(minefield: String) -> String {
  to_board(minefield)
  |> calculate_mines(#(0, 0))
  |> string.drop_right(1)
}
