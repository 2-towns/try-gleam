fn is_prime(n: Int, acc: Int) {
  case n % acc {
    _ if acc == 1 -> is_prime(n, acc + 1)
    _ if n == acc -> True
    x if x == 0 -> False
    _ -> is_prime(n, acc + 1)
  }
}

fn loop(nth: Int, n: Int, acc: Int) {
  case is_prime(n, 1) {
    True if nth == acc -> n
    True -> loop(nth, n + 1, acc + 1)
    False -> loop(nth, n + 1, acc)
  }
}

pub fn prime(number: Int) -> Result(Int, Nil) {
  case number {
    0 -> Error(Nil)
    x -> Ok(loop(x, 2, 1))
  }
}
