import gleam/int
import gleam/list
import gleam/result

pub type Character {
  Character(
    charisma: Int,
    constitution: Int,
    dexterity: Int,
    hitpoints: Int,
    intelligence: Int,
    strength: Int,
    wisdom: Int,
  )
}

pub fn generate_character() -> Character {
  let constitution = ability()
  Character(
    ability(),
    constitution,
    ability(),
    10 + modifier(constitution),
    ability(),
    ability(),
    ability(),
  )
}

pub fn modifier(score: Int) -> Int {
  { score - 10 }
  |> int.floor_divide(2)
  |> result.unwrap(0)
}

pub fn ability() -> Int {
  list.sort(
    [int.random(5) + 1, int.random(5) + 1, int.random(5) + 1, int.random(5) + 1],
    by: int.compare,
  )
  |> list.reverse
  |> list.take(3)
  |> int.sum
}
