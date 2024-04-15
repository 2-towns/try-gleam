import gleam/string
import gleam/list
import gleam/set

pub fn is_pangram(sentence: String) -> Bool {
  let letters = string.to_graphemes("abcdefghijklmnopqrstuvwxyz")
  string.lowercase(sentence)
  |> string.to_graphemes
  |> list.unique
  |> set.from_list
  |> set.intersection(set.from_list(letters))
  |> set.size
  |> fn(x) { x == 26 }
}
