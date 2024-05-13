import gleam/io
import gleam/string

fn apply_qu_rule(graphemes: List(String)) -> String {
  case graphemes {
    ["q", "u", ..rest] -> string.join(rest, "") <> "qu"
    x -> string.join(x, "")
  }
}

fn apply_consonent_rule(graphemes: List(String), consonent: String) -> String {
  case graphemes, consonent {
    ["u", ..rest], "q" -> string.join(rest, "") <> "quay"
    ["q", "u", ..rest], _ -> string.join(rest, "") <> consonent <> "quay"
    ["a", ..], _
    | ["e", ..], _
    | ["i", ..], _
    | ["o", ..], _
    | ["u", ..], _
    | ["y", ..], _ -> apply_qu_rule(graphemes) <> consonent <> "ay"
    [x, ..rest], _ -> apply_consonent_rule(rest, consonent <> x)
    x, _ -> string.join(x, "") <> "ay"
  }
}

fn translate_word(word: String) {
  let graphemes = string.to_graphemes(word)
  case graphemes {
    [first, "y"] -> "y" <> first <> "ay"
    ["a", ..]
    | ["e", ..]
    | ["i", ..]
    | ["o", ..]
    | ["u", ..]
    | ["x", "r", ..]
    | ["y", "t", ..] -> word <> "ay"
    [x, ..rest] -> {
      apply_consonent_rule(rest, x)
    }
    x -> string.join(x, "")
  }
}

fn translate_words(words: List(String)) -> List(String) {
  case words {
    [x, ..rest] -> [translate_word(x), ..translate_words(rest)]
    [] -> []
  }
}

pub fn translate(phrase: String) -> String {
  string.split(phrase, " ")
  |> translate_words
  |> string.join(" ")
}

pub fn main() {
  translate("xenon")
  |> io.debug
}
