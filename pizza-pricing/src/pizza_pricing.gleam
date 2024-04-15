import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(pizza: Pizza)
  ExtraToppings(pizza: Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
    ExtraSauce(x) -> 1 + pizza_price(x)
    ExtraToppings(x) -> 2 + pizza_price(x)
  }
}

fn order_price_sum(order: List(Pizza), sum: Int) -> Int {
  case order {
    [x, ..rest] -> order_price_sum(rest, sum + pizza_price(x))
    [] -> sum
  }
}

fn order_extra(order: List(Pizza)) {
  case list.length(order) {
    1 -> 3
    2 -> 2
    _ -> 0
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  order_price_sum(order, 0) + order_extra(order)
}
