import gleam/string

pub fn hey(remark: String) -> String {
  let cleaned = string.trim(remark)
  let is_question = string.ends_with(cleaned, "?")
  let is_uppercase =
    string.uppercase(cleaned) == cleaned && string.lowercase(cleaned) != cleaned
  case cleaned {
    "" -> "Fine. Be that way!"
    _ if is_uppercase && is_question -> "Calm down, I know what I'm doing!"
    _ if is_question -> "Sure."
    _ if is_uppercase -> "Whoa, chill out!"
    _ -> "Whatever."
  }
}
