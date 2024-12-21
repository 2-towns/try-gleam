import gleam/int
import gleam/io
import gleam/list
import gleam/result

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

fn classify_tail(number: Int, div: Int) -> Result(List(Int), Error) {
  case number % div {
    _ if number <= 0 -> Error(NonPositiveInt)
    _ if div * 2 > number -> Ok([])
    0 -> classify_tail(number, div + 1) |> result.map(list.prepend(_, div))
    _ -> classify_tail(number, div + 1)
  }
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  case classify_tail(number, 1) |> result.map(int.sum) {
    Ok(x) if x == number -> Ok(Perfect)
    Ok(x) if x > number -> Ok(Abundant)
    Ok(_) -> Ok(Deficient)
    Error(x) -> Error(x)
  }
}

pub fn main() {
  classify(28) |> io.debug
}
