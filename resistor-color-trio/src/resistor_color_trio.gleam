import gleam/result
import gleam/list
import gleam/int
import gleam/string

pub type Resistance {
  Resistance(unit: String, value: Int)
}

const values = [
  #("black", 0),
  #("brown", 1),
  #("red", 2),
  #("orange", 3),
  #("yellow", 4),
  #("green", 5),
  #("blue", 6),
  #("violet", 7),
  #("grey", 8),
  #("white", 9),
]

fn color_to_int(color: String) {
  let a =
    list.find(values, fn(x) { x.0 == color })
    |> result.unwrap(#("black", 0))

  a.1
}

fn metric_value(color: String) {
  color_to_int(color)
  |> int.modulo(3)
}

fn pad_zero(color: String) -> String {
  metric_value(color)
  |> result.unwrap(0)
  |> string.repeat("0", _)
}

fn adjust_value(value: Int) -> Int {
  case value {
    x if x >= 1000 ->
      int.divide(x, 1000)
      |> result.unwrap(0)
    _ -> value
  }
}

fn to_resistance(value: Int, color: String) -> Resistance {
  let metric = case value, color_to_int(color) {
    x, y if y > 6 || x >= 1_000_000_000 -> "giga"
    x, y if y > 4 || x >= 1_000_000 -> "mega"
    x, y if y > 2 || x >= 1000 -> "kilo"
    _, _ -> ""
  }

  Resistance(metric <> "ohms", adjust_value(value))
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  case colors {
    [x, y, z, ..] -> {
      int.parse(
        {
          color_to_int(x)
          |> int.to_string
        }
        <> {
          color_to_int(y)
          |> int.to_string
        }
        <> pad_zero(z),
      )
      |> result.unwrap(0)
      |> to_resistance(z)
      |> Ok
    }
    _ ->
      Resistance("ohms", 0)
      |> Ok
  }
}
