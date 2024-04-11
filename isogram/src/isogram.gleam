import gleam/string
import gleam/list

pub fn is_isogram(phrase phrase: String) -> Bool {
  let cleaned =
    string.replace(phrase, each: " ", with: "")
    |> string.replace(each: "-", with: "")

  cleaned
  |> string.lowercase
  |> string.to_graphemes
  |> list.unique
  |> list.length
  |> fn(x) { string.length(cleaned) == x }
}
