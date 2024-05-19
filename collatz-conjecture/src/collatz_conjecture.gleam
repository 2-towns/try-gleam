pub type Error {
  NonPositiveNumber
}

fn steps_tail(number: Int, acc: Int) -> Int {
  case number, number % 2 == 0 {
    1, _ -> acc
    _, True -> steps_tail(number / 2, acc + 1)
    _, False -> steps_tail(number * 3 + 1, acc + 1)
  }
}

pub fn steps(number: Int) -> Result(Int, Error) {
  case number {
    x if x <= 0 -> Error(NonPositiveNumber)
    x -> Ok(steps_tail(x, 0))
  }
}
