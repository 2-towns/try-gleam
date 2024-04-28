import gleam/list

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
}

pub fn commands(encoded_message: Int) -> List(Command) {
  case encoded_message {
    x if x >= 16 ->
      commands(x - 16)
      |> list.reverse
    x if x >= 8 -> list.append(commands(x - 8), [Jump])
    x if x >= 4 -> list.append(commands(x - 4), [CloseYourEyes])
    x if x >= 2 -> list.append(commands(x - 2), [DoubleBlink])
    x if x >= 1 -> [Wink]
    _ -> []
  }
}
