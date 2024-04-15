import gleam/dict.{type Dict}
import gleam/int
import gleam/string
import gleam/result

fn compute_score(letters: List(String), scores: Dict(String, Int)) {
  case letters {
    [x, ..rest] ->
      dict.get(scores, x)
      |> result.unwrap(0)
      |> int.add(compute_score(rest, scores))
    [] -> 0
  }
}

pub fn score(word: String) -> Int {
  let scores =
    dict.from_list([
      #("A", 1),
      #("E", 1),
      #("I", 1),
      #("O", 1),
      #("U", 1),
      #("L", 1),
      #("N", 1),
      #("R", 1),
      #("S", 1),
      #("T", 1),
      #("D", 2),
      #("G", 2),
      #("B", 3),
      #("C", 3),
      #("M", 3),
      #("P", 3),
      #("F", 4),
      #("H", 4),
      #("V", 4),
      #("W", 4),
      #("Y", 4),
      #("K", 5),
      #("J", 8),
      #("X", 8),
      #("Q", 10),
      #("Z", 10),
    ])
  string.uppercase(word)
  |> string.to_graphemes
  |> compute_score(scores)
}
