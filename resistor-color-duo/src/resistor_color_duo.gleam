import gleam/int
import gleam/list

pub type Color {
  Black
  Brown
  Red
  Orange
  Yellow
  Green
  Blue
  Violet
  Grey
  White
}

fn color_value(color: Color) {
  case color {
    Black -> "0"
    Brown -> "1"
    Red -> "2"
    Orange -> "3"
    Yellow -> "4"
    Green -> "5"
    Blue -> "6"
    Violet -> "7"
    Grey -> "8"
    White -> "9"
  }
}

pub fn value(colors: List(Color)) -> Result(Int, Nil) {
  let c = list.take(colors, 2)
  case list.length(c) {
    x if x != 2 -> Error(Nil)
    _ ->
      c
      |> list.map(color_value)
      |> list.fold("", fn(acc, value) { acc <> value })
      |> int.parse
  }
}
