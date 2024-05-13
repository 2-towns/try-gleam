import gleam/result

pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

fn change_player(game: Game) -> Game {
  case game.player {
    Black -> Game(..game, player: White)
    White -> Game(..game, player: Black)
  }
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  rule1(game)
  |> result.map(rule2)
  |> result.try(rule3)
  |> result.try(rule4)
  |> result.map(change_player)
  |> result.try_recover(fn(error) { Ok(Game(..game, error: error)) })
  |> result.unwrap(game)
}
