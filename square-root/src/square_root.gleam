fn tail(x: Int, start: Int, end: Int, acc: Int) {
  let mid = { start + end } / 2

  case mid * mid {
    _ if start > end -> acc
    c if c == x -> mid
    c if c < x -> tail(x, mid + 1, end, mid)
    _ -> tail(x, start, mid - 1, acc)
  }
}

pub fn square_root(radicand: Int) -> Int {
  case radicand {
    0 | 1 -> radicand
    _ -> tail(radicand, 1, radicand / 2, 0)
  }
}
