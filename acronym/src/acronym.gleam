import gleam/string
import gleam/list
import gleam/result

pub fn abbreviate(phrase phrase: String) -> String {
  string.replace(phrase, each: " ", with: "-")
  |> string.replace(each: "_", with: "")
  |> string.split(on: "-")
  |> list.map(fn(x) {
    string.first(x)
    |> result.unwrap("")
  })
  |> list.reduce(fn(acc, x) { acc <> x })
  |> result.unwrap("")
  |> string.uppercase
}
