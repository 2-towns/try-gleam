import gleam/list
import gleam/result
import gleam/string

const digits = "0123456789"

const letters = "abcdefghijklmnopqrstuvwxyz"

const punctuations = "?!@,;{}[]'\""

fn check_contains_letter(grapheme: String) {
  case string.contains(letters, grapheme) {
    True -> Error("letters not permitted")
    False -> Ok(grapheme)
  }
}

fn check_contains_letters(graphemes: List(String)) {
  list.try_each(graphemes, check_contains_letter)
  |> result.map(fn(_) { graphemes })
}

fn check_contains_punctuation(grapheme: String) {
  case string.contains(punctuations, grapheme) {
    True -> Error("punctuations not permitted")
    False -> Ok(grapheme)
  }
}

fn check_contains_punctuations(graphemes: List(String)) {
  list.try_each(graphemes, check_contains_punctuation)
  |> result.map(fn(_) { graphemes })
}

fn check_length(input: List(String)) {
  case list.length(input) {
    11 | 10 -> Ok(input)
    x if x < 10 -> Error("must not be fewer than 10 digits")
    _ -> Error("must not be greater than 11 digits")
  }
}

fn check_country_code(input: List(String)) {
  case
    list.length(input),
    list.first(input)
    |> result.unwrap("")
  {
    10, _ -> Ok(input)
    11, x if x == "1" -> Ok(list.drop(input, 1))
    _, _ -> Error("11 digits must start with 1")
  }
}

fn check_n_number(input: List(String)) {
  case input {
    [x, ..] if x == "0" -> Error("area code cannot start with zero")
    [x, ..] if x == "1" -> Error("area code cannot start with one")
    [_, _, _, x, ..] if x == "0" ->
      Error("exchange code cannot start with zero")
    [_, _, _, x, ..] if x == "1" -> Error("exchange code cannot start with one")
    _ -> Ok(input)
  }
}

pub fn clean(input: String) -> Result(String, String) {
  string.to_graphemes(input)
  |> check_contains_letters
  |> result.try(check_contains_punctuations)
  |> result.map(fn(graphemes) {
    list.filter(graphemes, fn(grapheme) {
      string.contains(does: digits, contain: grapheme)
    })
  })
  |> result.try(check_length)
  |> result.try(check_country_code)
  |> result.try(check_n_number)
  |> result.map(fn(graphemes) { string.join(graphemes, "") })
}
