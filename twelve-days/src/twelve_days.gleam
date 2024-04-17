import gleam/list
import gleam/string
import gleam/result

const days = [
  "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth",
  "ninth", "tenth", "eleventh", "twelfth",
]

const objects = [
  "twelve Drummers Drumming", "eleven Pipers Piping", "ten Lords-a-Leaping",
  "nine Ladies Dancing", "eight Maids-a-Milking", "seven Swans-a-Swimming",
  "six Geese-a-Laying", "five Gold Rings", "four Calling Birds",
  "three French Hens", "two Turtle Doves", "and a Partridge",
]

fn get_object(verse: Int) -> String {
  case verse {
    1 ->
      list.last(objects)
      |> result.unwrap("")
      |> string.replace(each: "and ", with: "")
    _ ->
      list.drop(objects, 12 - verse)
      |> string.join(", ")
  }
}

pub fn verse(number: Int) -> String {
  "On the "
  <> {
    list.at(days, number - 1)
    |> result.unwrap("")
  }
  <> " day of Christmas my true love gave to me: "
  <> get_object(number)
  <> " in a Pear Tree."
}

pub fn lyrics(from starting_verse: Int, to ending_verse: Int) -> String {
  case starting_verse, ending_verse {
    x, y if x > y -> ""
    x, y if x == y -> verse(starting_verse)
    _, _ ->
      verse(starting_verse) <> "\n" <> lyrics(starting_verse + 1, ending_verse)
  }
}
