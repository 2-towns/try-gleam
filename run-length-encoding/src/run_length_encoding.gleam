import gleam/int
import gleam/string
import gleam/result

fn encode_graphemes(graphemes: List(String), current: String, sum: Int) {
  case graphemes {
    [x, ..rest] if x == current -> encode_graphemes(rest, x, 1 + sum)
    [x, ..rest] if sum > 1 ->
      int.to_string(sum) <> current <> encode_graphemes(rest, x, 1)
    [x, ..rest] -> current <> encode_graphemes(rest, x, 1)
    [] if sum > 1 -> int.to_string(sum) <> current
    [] -> current
  }
}

pub fn encode(plaintext: String) -> String {
  string.to_graphemes(plaintext)
  |> encode_graphemes("", 0)
}

fn is_letter(char: String) {
  string.contains(" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiklmnoqrstuvwxyz", char)
}

fn decode_graphemes(graphemes: List(String), current: String) {
  case graphemes {
    [x, ..rest] -> {
      case is_letter(x) {
        True ->
          int.parse(current)
          |> result.unwrap(1)
          |> string.repeat(x, _)
          |> fn(y) { string.concat([y, decode_graphemes(rest, "")]) }
        False -> decode_graphemes(rest, current <> x)
      }
    }
    [] -> ""
  }
}

pub fn decode(ciphertext: String) -> String {
  string.to_graphemes(ciphertext)
  |> decode_graphemes("")
}
