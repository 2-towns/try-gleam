import gleam/list
import gleam/dict.{type Dict}
import gleam/string

type Board =
  Dict(Coordinate, String)

type Coordinate =
  #(Int, Int)

fn parse_row(graphemes: List(String), index: Int) -> Dict(Coordinate, String) {
  list.index_fold(graphemes, dict.new(), fn(acc, item, i) {
    dict.insert(acc, #(index, i), item)
  })
}

fn create_board(input: String) {
  string.split(input, "\n")
  |> list.index_fold(dict.new(), fn(acc, item, i) {
    dict.merge(acc, parse_row(string.to_graphemes(item), i))
  })
}

fn find_corners(board: Board, a: Coordinate, b: Coordinate) {
  let limit = b.1 - 1
  case dict.get(board, a), dict.get(board, b) {
    Ok("+"), Ok("+") ->
      list.concat([
        find_bottom_corners(board, #(a.0 + 1, a.1), b),
        find_corners(board, a, #(b.0, b.1 + 1)),
      ])
    Ok("+"), Ok(" ") -> find_corners(board, #(a.0, a.1 + 1), #(a.0, a.1 + 2))
    Ok("+"), Ok(_) ->
      list.concat([find_corners(board, #(a.0, a.1), #(b.0, b.1 + 1))])
    Ok(_), Ok(_) -> find_corners(board, #(a.0, a.1 + 1), #(a.0, a.1 + 2))
    Error(_), _ -> []
    _, Error(_) if a.1 < limit ->
      find_corners(board, #(a.0, a.1 + 1), #(a.0, a.1 + 2))
    _, Error(_) -> find_corners(board, #(a.0 + 1, 0), #(a.0 + 1, 1))
  }
}

fn find_bottom_corners(board: Board, a: Coordinate, b: Coordinate) {
  case dict.get(board, a) {
    Ok("+") ->
      list.concat([
        find_bottom_right_corner(board, a, #(b.0 + 1, b.1)),
        find_bottom_corners(board, #(a.0 + 1, a.1), b),
      ])
    Ok("|") -> find_bottom_corners(board, #(a.0 + 1, a.1), b)
    _ -> []
  }
}

fn find_bottom_right_corner(board: Board, a: Coordinate, b: Coordinate) {
  case dict.get(board, b) {
    Ok("+") if a.0 == b.0 -> {
      list.concat([
        find_complete_line(board, #(a.0, a.1 + 1), b),
        find_bottom_right_corner(board, a, #(b.0 + 1, b.1)),
      ])
    }
    Ok("|") | Ok("+") -> find_bottom_right_corner(board, a, #(b.0 + 1, b.1))
    _ -> []
  }
}

fn find_complete_line(board: Board, a: Coordinate, b: Coordinate) {
  case dict.get(board, a) {
    Ok("+") if a.1 == b.1 -> [a]
    Ok("-") | Ok("+") -> find_complete_line(board, #(a.0, a.1 + 1), b)
    _ -> []
  }
}

pub fn rectangles(input: String) -> Int {
  string.drop_right(input, 1)
  |> string.drop_left(1)
  |> create_board
  |> find_corners(#(0, 0), #(0, 1))
  |> list.length
}
