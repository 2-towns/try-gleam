fn square_of_sum_loop(n: Int) -> Int {
  case n {
    1 -> 1
    _ -> n + square_of_sum_loop(n - 1)
  }
}

pub fn square_of_sum(n: Int) -> Int {
  let result = square_of_sum_loop(n)
  result * result
}

fn sum_of_squares_loop(n: Int) -> Int {
  case n {
    1 -> 1
    _ -> n * n + sum_of_squares_loop(n - 1)
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  sum_of_squares_loop(n)
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
