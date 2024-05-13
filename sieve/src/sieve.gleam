fn is_prime(n: Int, acc: Int) {
  case n % acc {
    _ if acc == 1 -> is_prime(n, acc + 1)
    _ if n == acc -> True
    x if x == 0 -> False
    _ -> is_prime(n, acc + 1)
  }
}

pub fn primes_up_to_tail(upper_bound: Int, acc: Int) {
  case acc {
    x if upper_bound < x -> []
    x -> {
      case is_prime(acc, 2) {
        True -> [x, ..primes_up_to_tail(upper_bound, acc + 1)]
        False -> primes_up_to_tail(upper_bound, acc + 1)
      }
    }
  }
}

pub fn primes_up_to(upper_bound: Int) -> List(Int) {
  case upper_bound {
    1 -> []
    _ -> primes_up_to_tail(upper_bound, 2)
  }
}
