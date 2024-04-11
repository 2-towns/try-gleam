import gleam/iterator.{type Iterator}

pub type Item {
  Item(name: String, price: Int, quantity: Int)
}

pub fn item_names(items: Iterator(Item)) -> Iterator(String) {
  iterator.map(items, fn(x) { x.name })
}

pub fn cheap(items: Iterator(Item)) -> Iterator(Item) {
  iterator.filter(items, fn(x) { x.price < 30 })
}

pub fn out_of_stock(items: Iterator(Item)) -> Iterator(Item) {
  iterator.filter(items, fn(x) { x.quantity == 0 })
}

pub fn total_stock(items: Iterator(Item)) -> Int {
  iterator.fold(from: 0, over: items, with: fn(acc, x) { acc + x.quantity })
}
