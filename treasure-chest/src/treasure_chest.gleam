pub type TreasureChest(treasure) {
  TreasureChest(password: String, value: treasure)
}

pub type UnlockResult(value) {
  Unlocked(value)
  WrongPassword
}

pub fn get_treasure(
  chest: TreasureChest(treasure),
  password: String,
) -> UnlockResult(treasure) {
  case chest {
    TreasureChest(pwd, ..) if pwd == password -> Unlocked(chest.value)
    _ -> WrongPassword
  }
}
