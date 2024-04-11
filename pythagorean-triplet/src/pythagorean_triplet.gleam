import gleam/io
import gleam/list

pub type Triplet {
  Triplet(Int, Int, Int)
}

fn get_triplet(a, b, c: Int) -> List(Triplet) {
  let is_triplet = { a * a + b * b } == c * c
  case is_triplet {
    True -> [Triplet(a, b, c)]
    False -> []
  }
}

fn get_triplets(a, b, c: Int) -> List(Triplet) {
  case a, b, c - a - b {
    x, _, _ if x == c -> []
    _, x, _ if x == c -> get_triplets(a + 1, a + 2, c)
    _, _, z -> list.concat([get_triplet(a, b, z), get_triplets(a, b + 1, c)])
  }
}

pub fn triplets_with_sum(sum: Int) -> List(Triplet) {
  get_triplets(1, 2, sum)
}

pub fn main() {
  io.debug(triplets_with_sum(12))
}
