import gleam/list
import gleam/result
import gleam/string

fn proteins_tail(graphemes: List(String)) -> Result(List(String), Nil) {
  let protein = case graphemes {
    ["A", "U", "G", ..] -> Ok("Methionine")
    ["U", "U", "U", ..] -> Ok("Phenylalanine")
    ["U", "U", "C", ..] -> Ok("Phenylalanine")
    ["U", "U", "A", ..] -> Ok("Leucine")
    ["U", "U", "G", ..] -> Ok("Leucine")
    ["U", "C", "U", ..] -> Ok("Serine")
    ["U", "C", "C", ..] -> Ok("Serine")
    ["U", "C", "A", ..] -> Ok("Serine")
    ["U", "C", "G", ..] -> Ok("Serine")
    ["U", "A", "U", ..] -> Ok("Tyrosine")
    ["U", "A", "C", ..] -> Ok("Tyrosine")
    ["U", "G", "U", ..] -> Ok("Cysteine")
    ["U", "G", "C", ..] -> Ok("Cysteine")
    ["U", "G", "G", ..] -> Ok("Tryptophan")
    ["U", "A", "A", ..] -> Ok("")
    ["U", "A", "G", ..] -> Ok("")
    ["U", "G", "A", ..] -> Ok("")
    [] -> Ok("")
    _ -> Error(Nil)
  }

  case protein {
    Error(Nil) -> Error(Nil)
    Ok("") -> Ok([])
    Ok(x) ->
      proteins_tail(list.drop(graphemes, 3))
      |> result.map(list.prepend(_, x))
  }
}

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  proteins_tail(string.to_graphemes(rna))
}
