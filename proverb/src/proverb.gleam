import gleam/list
import gleam/result

fn recite_loop(inputs: List(String), first: String) {
  case inputs {
    [x, y, ..rest] ->
      "For want of a "
      <> x
      <> " the "
      <> y
      <> " was lost.\n"
      <> recite_loop([y, ..rest], first)
    [_] -> "And all for the want of a " <> first <> "."
    [] -> ""
  }
}

pub fn recite(inputs: List(String)) -> String {
  list.first(inputs)
  |> result.unwrap("")
  |> recite_loop(inputs, _)
}
