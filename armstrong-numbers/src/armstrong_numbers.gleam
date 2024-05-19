import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn safe_parse_int(s: String) {
  int.parse(s)
  |> result.unwrap(0)
}

pub fn is_armstrong_number(number: Int) -> Bool {
  int.to_string(number)
  |> string.to_graphemes
  |> fn(graphemes) {
    list.fold(graphemes, 0, fn(acc, grapheme) {
      list.repeat(grapheme, list.length(graphemes))
      |> list.fold(1, fn(acc, grapheme) { acc * safe_parse_int(grapheme) })
      |> int.add(acc)
    })
  }
  |> fn(value) { value == number }
}
