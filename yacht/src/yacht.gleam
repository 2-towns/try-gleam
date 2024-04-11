import gleam/list
import gleam/int

pub type Category {
  Ones
  Twos
  Threes
  Fours
  Fives
  Sixes
  FullHouse
  FourOfAKind
  LittleStraight
  BigStraight
  Choice
  Yacht
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category, list.sort(dice, int.compare) {
    Ones, [1, ..rest] -> 1 + score(Ones, rest)
    Ones, [_, ..rest] -> score(Ones, rest)
    Twos, [2, ..rest] -> 2 + score(Twos, rest)
    Twos, [_, ..rest] -> score(Twos, rest)
    Threes, [3, ..rest] -> 3 + score(Threes, rest)
    Threes, [_, ..rest] -> score(Threes, rest)
    Fours, [4, ..rest] -> 4 + score(Fours, rest)
    Fours, [_, ..rest] -> score(Fours, rest)
    Fives, [5, ..rest] -> 5 + score(Fives, rest)
    Fives, [_, ..rest] -> score(Fives, rest)
    Sixes, [6, ..rest] -> 6 + score(Sixes, rest)
    Sixes, [_, ..rest] -> score(Sixes, rest)
    FullHouse, [x, y, z, w, v] if x == y
      && y == z
      && w == v
      && z != w
      || x == y
      && y != z
      && z == w
      && w == v -> x + y + z + w + v
    FourOfAKind, [x, y, z, w, _] if x == y && y == z && z == w -> x + y + z + w
    FourOfAKind, [_, y, z, w, v] if y == z && z == w && w == v -> y + z + w + v
    LittleStraight, [1, 2, 3, 4, 5] -> 30
    BigStraight, [2, 3, 4, 5, 6] -> 30
    Choice, [x, ..rest] -> x + score(Choice, rest)
    Yacht, [x, y, z, w, v] if x == y && y == z && z == w && w == v -> 50
    _, _ -> 0
  }
}
