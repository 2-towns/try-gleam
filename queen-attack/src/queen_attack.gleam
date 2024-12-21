pub type Position {
  Position(row: Int, column: Int)
}

pub type Error {
  RowTooSmall
  RowTooLarge
  ColumnTooSmall
  ColumnTooLarge
}

pub fn create(queen: Position) -> Result(Nil, Error) {
  case queen {
    Position(row, _) if row < 0 -> Error(RowTooSmall)
    Position(row, _) if row >= 8 -> Error(RowTooLarge)
    Position(_, col) if col < 0 -> Error(ColumnTooSmall)
    Position(_, col) if col >= 8 -> Error(ColumnTooLarge)
    _ -> Ok(Nil)
  }
}

pub fn can_attack_tail(
  black_queen black_queen: Position,
  white_queen white_queen: Position,
) -> Bool {
  case create(black_queen), black_queen, white_queen {
    Error(_), _, _ -> False
    Ok(Nil), Position(a, b), Position(c, d) if a < c && b < d ->
      { a + 1 == c && b + 1 == d }
      || can_attack_tail(Position(a + 1, b + 1), white_queen)
    Ok(Nil), Position(a, b), Position(c, d) if a < c && b > d ->
      { a + 1 == c && b - 1 == d }
      || can_attack_tail(Position(a + 1, b - 1), white_queen)
    Ok(Nil), Position(a, b), Position(c, d) if a > c && b > d ->
      { a - 1 == c && b - 1 == d }
      || can_attack_tail(Position(a - 1, b - 1), white_queen)
    Ok(Nil), Position(a, b), Position(c, d) if a > c && b < d ->
      { a - 1 == c && b + 1 == d }
      || can_attack_tail(Position(a - 1, b + 1), white_queen)
    _, _, _ -> False
  }
}

pub fn can_attack(
  black_queen black_queen: Position,
  white_queen white_queen: Position,
) -> Bool {
  case black_queen, white_queen {
    Position(a, b), Position(c, d) if a == c || b == d -> True
    _, _ -> can_attack_tail(black_queen, white_queen)
  }
}

pub fn main() {
  can_attack(
    black_queen: Position(row: 2, column: 5),
    white_queen: Position(row: 4, column: 1),
  )
}
