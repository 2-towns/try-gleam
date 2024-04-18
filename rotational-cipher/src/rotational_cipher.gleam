import gleam/int
import gleam/list
import gleam/result
import gleam/string

const lowercases = "abcdefghijklmnopqrstuvwxyz"

const uppercases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

fn is_lowercase(letter: String) {
  string.contains(lowercases, letter)
}

fn is_uppercase(letter: String) {
  string.contains(uppercases, letter)
}

fn next_codepoint(codepoint: Int, base: Int) {
  case base + 26 {
    x if codepoint >= x -> base + codepoint - x
    _ -> codepoint
  }
}

fn codepoint_to_int(codepoint: Result(UtfCodepoint, Nil)) -> Int {
  case codepoint {
    Ok(x) -> string.utf_codepoint_to_int(x)
    _ -> 0
  }
}

fn codepoint_to_string(codepoint: Result(UtfCodepoint, Nil)) -> String {
  case codepoint {
    Ok(x) -> string.from_utf_codepoints([x])
    _ -> ""
  }
}

fn rotate_letter(letter: String, shift_key: Int, base: Int) {
  string.to_utf_codepoints(letter)
  |> list.first
  |> codepoint_to_int
  |> int.add(shift_key % 26)
  |> next_codepoint(base)
  |> string.utf_codepoint
  |> codepoint_to_string
}

pub fn rotate(shift_key: Int, text: String) -> String {
  let letter =
    string.first(text)
    |> result.unwrap("")

  case string.length(text) {
    0 -> ""
    _ -> {
      case is_lowercase(letter), is_uppercase(letter) {
        True, _ ->
          rotate_letter(letter, shift_key, 97)
          |> string.append(rotate(shift_key, string.drop_left(text, 1)))
        _, True ->
          rotate_letter(letter, shift_key, 65)
          |> string.append(rotate(shift_key, string.drop_left(text, 1)))
        _, _ -> letter <> rotate(shift_key, string.drop_left(text, 1))
      }
    }
  }
}
