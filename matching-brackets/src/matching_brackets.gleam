import gleam/string
import gleam/result

pub fn loop(value: String, accumulator: String) -> Bool {
  let #(first, rest) = result.unwrap(string.pop_grapheme(value), #("", ""))
  let last = result.unwrap(string.last(accumulator), "")
  case first {
    "[" -> loop(rest, accumulator <> "[")
    "]" -> last == "[" && loop(rest, string.drop_right(accumulator, 1))
    "{" -> loop(rest, accumulator <> "{")
    "}" -> last == "{" && loop(rest, string.drop_right(accumulator, 1))
    "(" -> loop(rest, accumulator <> "(")
    ")" -> last == "(" && loop(rest, string.drop_right(accumulator, 1))
    "" -> accumulator == ""
    _ -> loop(rest, accumulator)
  }
}

pub fn is_paired(value: String) -> Bool {
  loop(value, "")
}
