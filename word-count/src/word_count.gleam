import gleam/dict.{type Dict}
import gleam/string
import gleam/list

const letters = "abcdefghijklmnopqrstuvwxyz'1234567890"

fn count(words: List(String), word: String) -> Int {
  list.filter(words, fn(x) { x == word })
  |> list.length
}

fn clean(word: String) {
  clean_left(word)
  |> clean_right
  |> string.to_graphemes
  |> list.filter(fn(x) { string.contains(letters, x) })
  |> list.fold("", fn(acc, x) { acc <> x })
}

fn clean_left(word: String) {
  case string.first(word) {
    Ok("'") -> string.drop_left(word, up_to: 1)
    _ -> word
  }
}

fn clean_right(word: String) {
  case string.last(word) {
    Ok("'") -> string.drop_right(word, up_to: 1)
    _ -> word
  }
}

pub fn count_words(input: String) -> Dict(String, Int) {
  let words =
    string.replace(input, each: ":", with: " ")
    |> string.replace(each: "!", with: " ")
    |> string.replace(each: "?", with: " ")
    |> string.replace(each: "\t", with: " ")
    |> string.replace(each: "\n", with: " ")
    |> string.replace(each: ",", with: " ")
    |> string.replace(each: ".", with: " ")
    |> string.lowercase
    |> string.split(" ")
    |> list.map(clean)
    |> list.filter(fn(x) { string.is_empty(x) == False })

  list.unique(words)
  |> list.fold(dict.new(), fn(acc, x) { dict.insert(acc, x, count(words, x)) })
}
