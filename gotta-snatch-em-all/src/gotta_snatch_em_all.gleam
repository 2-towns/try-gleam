import gleam/set.{type Set}
import gleam/list
import gleam/string
import gleam/result

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  case set.contains(collection, my_card), set.contains(collection, their_card) {
    True, False -> #(
      True,
      set.delete(collection, my_card)
        |> set.insert(their_card),
    )
    True, True -> #(False, set.delete(collection, my_card))
    False, _ -> #(False, set.insert(collection, their_card))
  }
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  list.reduce(collections, fn(acc, item) { set.intersection(acc, item) })
  |> result.unwrap(set.new())
  |> set.to_list
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  list.reduce(collections, fn(acc, item) { set.union(acc, item) })
  |> result.unwrap(set.new())
  |> set.size
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.filter(collection, fn(item) { string.starts_with(item, "Shiny") })
}
