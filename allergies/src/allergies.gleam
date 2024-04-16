import gleam/dict
import gleam/list as l

pub type Allergen {
  Eggs
  Peanuts
  Shellfish
  Strawberries
  Tomatoes
  Chocolate
  Pollen
  Cats
}

const allergens = [
  #(1, Eggs),
  #(2, Peanuts),
  #(4, Shellfish),
  #(8, Strawberries),
  #(16, Tomatoes),
  #(32, Chocolate),
  #(64, Pollen),
  #(128, Cats),
]

pub fn allergic_to(allergen: Allergen, score: Int) -> Bool {
  let power = next_power(score, 1)

  dict.from_list(allergens)
  |> dict.get(power)
  |> fn(x) {
    x == Ok(allergen)
    || { { score - power } >= 1 && allergic_to(allergen, score - power) }
  }
}

fn next_power(score: Int, acc: Int) {
  case score, acc * 2 <= score {
    0, _ -> 0
    1, _ -> 1
    _, True -> next_power(score, acc * 2)
    _, False -> acc
  }
}

pub fn list(score: Int) -> List(Allergen) {
  let scores = dict.from_list(allergens)
  let power = next_power(score, 1)
  case score, dict.get(scores, power) {
    1, _ -> [Eggs]
    0, _ -> []
    _, Ok(x) -> l.append(list(score - power), [x])
    _, _ -> list(score - power)
  }
}
