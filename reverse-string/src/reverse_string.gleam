import gleam/string

fn reverse_loop(letters: List(String)) -> String {
  case letters {
    [] -> ""
    [x, ..rest] -> reverse_loop(rest) <> x
  }
}

pub fn reverse(value: String) -> String {
  reverse_loop(string.to_graphemes(value))
}
