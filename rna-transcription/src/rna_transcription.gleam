import gleam/string

fn to_rna_tail(graphemes: List(String)) {
  case graphemes {
    ["G", ..rest] -> "C" <> to_rna_tail(rest)
    ["C", ..rest] -> "G" <> to_rna_tail(rest)
    ["T", ..rest] -> "A" <> to_rna_tail(rest)
    ["A", ..rest] -> "U" <> to_rna_tail(rest)
    [_, ..] -> "INVALID"
    [] -> ""
  }
}

pub fn to_rna(dna: String) -> Result(String, Nil) {
  let value =
    string.to_graphemes(dna)
    |> to_rna_tail

  case value {
    "INVALID" -> Error(Nil)
    x -> Ok(x)
  }
}
