import gleam/result
import gleam/string
import gleam/io

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction, position)
}

fn left_position(direction: Direction) {
  case direction {
    North -> West
    West -> South
    South -> East
    East -> North
  }
}

fn right_position(direction: Direction) {
  case direction {
    North -> East
    West -> North
    South -> West
    East -> South
  }
}

fn next_direction(letter: String, direction: Direction) -> Direction {
  case letter {
    "L" -> left_position(direction)
    "R" -> right_position(direction)
    _ -> direction
  }
}

fn next_position(direction: Direction, position: Position) {
  case direction {
    North -> Position(x: position.x, y: position.y + 1)
    South -> Position(x: position.x, y: position.y - 1)
    West -> Position(x: position.x - 1, y: position.y)
    East -> Position(x: position.x + 1, y: position.y)
  }
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  let #(letter, rest) =
    result.unwrap(string.pop_grapheme(instructions), #("", ""))

  case letter {
    "" -> create(direction, position)
    "A" -> {
      let new_direction = next_direction(letter, direction)
      let new_position = next_position(new_direction, position)
      move(new_direction, new_position, rest)
    }
    _ -> {
      let new_direction = next_direction(letter, direction)
      move(new_direction, position, rest)
    }
  }
}

pub fn main() {
  io.debug(move(North, Position(x: 0, y: 0), "R"))
}
