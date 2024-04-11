import gleam/result
import gleam/string
import gleam/regex
import gleam/list

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(re) = regex.from_string("^\\[(DEBUG|INFO|WARNING|ERROR)]")
  regex.check(re, line)
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("(<[\\~\\*\\-\\=]*>)")
  regex.split(with: re, content: line)
  |> list.filter(fn(x) { !string.starts_with(x, "<") })
}

pub fn get_content(m: regex.Match) -> String {
  m.content
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regex.from_string("User(\\s|\\t\\n)+[^()\\s|\\t\\n)]+")
  case regex.check(re, line) {
    False -> line
    True -> {
      regex.scan(with: re, content: line)
      |> list.first
      |> result.unwrap(regex.Match(content: "", submatches: []))
      |> get_content
      |> string.split("User")
      |> list.at(1)
      |> result.unwrap("")
      |> string.trim
      |> fn(x) { "[USER] " <> x <> " " <> line }
    }
  }
}
