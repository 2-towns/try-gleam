import gleam/int
import gleam/list
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  case game.frames, knocked_pins {
    // Invalid pins
    _, pins if pins < 0 || pins > 10 -> Error(InvalidPinCount)

    //  Pins addition is invalid
    [Frame([a], _), ..], pins if a + pins > 10 && a != 10 ->
      Error(InvalidPinCount)

    // Double strike 
    [Frame([10], _), Frame([10], f), ..rest], pins ->
      Ok(
        Game([
          Frame([pins], []),
          Frame([10], [pins]),
          Frame([10], [pins, ..f]),
          ..rest
        ]),
      )

    // Previous strike first throw
    [Frame([10], f), ..rest], pins ->
      Ok(Game([Frame([pins], []), Frame([10], [pins, ..f]), ..rest]))

    // Previous strike second throw
    [Frame([a], _), Frame([10], f), ..rest], pins ->
      Ok(Game([Frame([pins, a], []), Frame([10], [pins, ..f]), ..rest]))

    // Spare 
    [Frame([d, e], _), ..rest], pins if d + e == 10 ->
      Ok(Game([Frame([pins], []), Frame([d, e], [pins]), ..rest]))

    // Game is already complete
    [Frame([_, __], _), _, _, _, _, _, _, _, _, _], _ -> Error(GameComplete)

    // Adding bonus after spare or strike 
    [_, _, _, _, _, _, _, _, _, _, _], _ -> Error(GameComplete)

    // New open frame 
    [Frame([a, b], c), ..rest], pins ->
      Ok(Game([Frame([pins], []), Frame([a, b], c), ..rest]))

    //  Open frame 
    [Frame([a], c), ..rest], pins -> Ok(Game([Frame([a, pins], c), ..rest]))

    // Default 
    rest, pins -> Ok(Game([Frame([pins], []), ..rest]))
  }
}

fn score_tail(frames: List(Frame)) -> Result(Int, Error) {
  case frames {
    [] -> Ok(0)
    [Frame(x, y), ..rest] ->
      score_tail(rest)
      |> result.map(int.add(_, int.sum(x) + int.sum(y)))
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case game.frames, list.length(game.frames) {
    // Less then 10 frames
    _, x if x < 10 -> Error(GameNotComplete)

    // Strike with only one bonus
    [Frame([_], _), Frame([10], _), _, _, _, _, _, _, _, _, _], _ ->
      Error(GameNotComplete)

    // Spare without bonus
    [Frame([a, b], _), _, _, _, _, _, _, _, _, _], _ if a + b == 10 ->
      Error(GameNotComplete)

    // Last strike with only no bonus
    [Frame([10], _), _, _, _, _, _, _, _, _, _], _ -> Error(GameNotComplete)

    _, _ -> score_tail(game.frames |> list.reverse |> list.take(10))
  }
}
