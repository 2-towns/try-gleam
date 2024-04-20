import gleam/list
import gleam/string

const verses = [
  #("house that Jack built", ""),
  #("malt", "lay in"),
  #("rat", "ate"),
  #("cat", "killed"),
  #("dog", "worried"),
  #("cow with the crumpled horn", "tossed"),
  #("maiden all forlorn", "milked"),
  #("man all tattered and torn", "kissed"),
  #("priest all shaven and shorn", "married"),
  #("rooster that crowed in the morn", "woke"),
  #("farmer sowing his corn", "kept"),
  #("horse and the hound and the horn", "belonged to"),
]

fn loop(verses: List(#(String, String)), previous: String) -> String {
  case verses, previous {
    [verse, ..rest], "" -> "This is the " <> verse.0 <> loop(rest, verse.1)
    [verse, ..rest], x ->
      " that " <> x <> " the " <> verse.0 <> loop(rest, verse.1)
    _, _ -> "."
  }
}

pub fn recite(start_verse start_verse: Int, end_verse end_verse: Int) -> String {
  list.range(start_verse, end_verse)
  |> list.map(fn(x) {
    list.take(verses, x)
    |> list.reverse
    |> loop("")
  })
  |> string.join("\n")
}
