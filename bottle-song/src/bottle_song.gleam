import gleam/string
import gleam/io

fn to_string(take_down: Int) -> String {
  case take_down {
    1 -> "One"
    2 -> "Two"
    3 -> "Three"
    4 -> "Four"
    5 -> "Five"
    6 -> "Six"
    7 -> "Seven"
    8 -> "Eight"
    9 -> "Nine"
    10 -> "Ten"
    _ -> "no"
  }
}

pub fn verse_one(bottles: Int) -> String {
  case bottles {
    1 -> to_string(bottles) <> " green bottle hanging on the wall,\n"
    _ -> to_string(bottles) <> " green bottles hanging on the wall,\n"
  }
}

pub fn verse_three(bottles: Int) -> String {
  case bottles {
    1 -> " green bottle hanging on the wall."
    _ -> " green bottles hanging on the wall."
  }
}

fn recite_loop(start_bottles: Int, take_down: Int) -> List(String) {
  case take_down {
    _ if start_bottles > 0 && take_down > 0 -> {
      let verses =
        string.repeat(verse_one(start_bottles), 2)
        <> "And if one green bottle should accidentally fall,\n"
        <> "There'll be "
        <> string.lowercase(to_string(start_bottles - 1))
        <> verse_three(start_bottles - 1)
      [verses, ..recite_loop(start_bottles - 1, take_down - 1)]
    }
    _ -> []
  }
}

pub fn recite(
  start_bottles start_bottles: Int,
  take_down take_down: Int,
) -> String {
  recite_loop(start_bottles, take_down)
  |> string.join("\n\n")
}

pub fn main() {
  io.print(recite(10, 1))
}
