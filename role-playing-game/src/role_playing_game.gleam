import gleam/option.{type Option, None, Some}
import gleam/int

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  option.unwrap(player.name, "Mighty Magician")
}

pub fn revive(player: Player) -> Option(Player) {
  case player {
    _ if player.health == 0 && player.level >= 10 ->
      Some(Player(..player, health: 100, mana: Some(100)))
    _ if player.health == 0 -> Some(Player(..player, health: 100, mana: None))
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  let mana = option.unwrap(player.mana, 0)
  case player {
    _ if mana == 0 -> #(
      Player(..player, health: int.max(player.health - cost, 0)),
      0,
    )
    _ if mana >= cost -> #(Player(..player, mana: Some(mana - cost)), cost * 2)
    _ -> #(player, 0)
  }
}
