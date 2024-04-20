import gleam/list
import gleam/result
import gleam/string

type Rectangle =
  #(Int, Int)

const alphabet = "abcdefghiklmnopqrstuvwyxz123456789"

fn is_alpha(letter: String) {
  string.contains(alphabet, letter)
}

fn find_columns_and_rows(plaintext: String, columns: Int, rows: Int) {
  case columns * rows >= string.length(plaintext) {
    True -> #(columns, rows)
    False if columns == rows ->
      find_columns_and_rows(plaintext, columns + 1, rows)
    _ -> find_columns_and_rows(plaintext, columns, rows + 1)
  }
}

fn extract_letter(graphemes: List(String), index: Int) {
  list.at(graphemes, index)
  |> result.unwrap(" ")
}

fn code(graphemes: List(String), rectangle: Rectangle, current: Rectangle) {
  case current.0 >= rectangle.0 {
    True -> ""
    _ if current.1 < rectangle.1 ->
      extract_letter(graphemes, current.0 + current.1 * rectangle.0)
      <> code(graphemes, rectangle, #(current.0, current.1 + 1))
    _ if current.0 < rectangle.0 ->
      extract_letter(graphemes, current.0 + current.1 * rectangle.0)
      <> code(graphemes, rectangle, #(current.0 + 1, 0))
    _ -> ""
  }
}

pub fn ciphertext(plaintext: String) -> String {
  let normalized =
    string.lowercase(plaintext)
    |> string.to_graphemes
    |> list.filter(is_alpha)

  find_columns_and_rows(string.join(normalized, ""), 0, 0)
  |> code(normalized, _, #(0, 0))
  |> string.drop_right(1)
}
