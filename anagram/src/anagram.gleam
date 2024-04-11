import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let lowercase_word = string.lowercase(word)
  let permutations =
    lowercase_word
    |> string.to_graphemes
    |> list.permutations

  list.filter(candidates, fn(w) {
    string.lowercase(w) != lowercase_word
    && string.to_graphemes(string.lowercase(w))
    |> list.contains(permutations, _)
  })
}
