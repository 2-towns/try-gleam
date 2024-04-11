import gleam/list
import gleam/string
import gleam/result

const separator = " "

fn line_pad_right(letter: String, index: Int) -> String {
  case index {
    0 -> ""
    _ -> string.repeat(separator, 2 * { index - 1 } + 1) <> letter
  }
}

fn print_diamond_line(letter: String, size: Int, index: Int) -> String {
  let start = string.repeat(separator, size)
  let end = string.repeat(separator, size)

  start <> letter <> line_pad_right(letter, index) <> end <> "\n"
}

fn build_diamond_top(letters: List(String), diamond_size: Int) {
  let size = list.length(letters)
  let index = diamond_size - size

  case letters {
    [letter] -> print_diamond_line(letter, size, index)
    [letter, ..rest] ->
      print_diamond_line(letter, size, index)
      <> build_diamond_top(rest, diamond_size)
    [] -> ""
  }
}

pub fn build(letter: String) -> String {
  case letter {
    "A" -> "A"
    _ -> {
      let parts = string.split("ABCDEFGHIJKLMNOPQRSTUVWXYZ", on: letter)
      let letters = result.unwrap(list.first(parts), "")
      let diamond_size = string.length(letters)

      let diamond_top =
        build_diamond_top(string.to_graphemes(letters), diamond_size)

      diamond_top
      <> letter
      <> line_pad_right(letter, diamond_size)
      <> string.reverse(diamond_top)
    }
  }
}
