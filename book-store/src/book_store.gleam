import gleam/list
import gleam/int
import gleam/result
import gleam/float

// Price in cents 
const book_price = 800.0

// Remove a group of books from the current book list 
fn remove_group(books: List(Int), group: List(Int)) -> List(Int) {
  case group {
    [] -> books
    [x, ..rest] -> {
      let #(_, new_books) =
        list.pop(books, fn(y) { x == y })
        |> result.unwrap(#(0, books))

      remove_group(new_books, rest)
    }
  }
}

fn get_book_price_with_discount(group: Int) {
  let percent = case group {
    2 -> 0.95
    3 -> 0.9
    4 -> 0.8
    5 -> 0.75
    _ -> 0.1
  }
  percent *. int.to_float(group) *. book_price
}

// Put the duplicate books into the head of the array 
// in order to maximise the group combinaison calculations. 
// [1, 1, 2, 3, 4, 4, 5, 5] will become [1, 1, 4, 4, 5, 5, 2, 3] 
fn group_by_duplicate(books: List(Int)) -> List(Int) {
  case books {
    [] -> []
    [x, ..rest] -> {
      let list_without_current = list.filter(rest, fn(v) { v != x })
      let currents = list.length(books) - list.length(list_without_current)
      let data = case currents {
        1 ->
          group_by_duplicate(list_without_current)
          |> list.append([x])
        n ->
          list.repeat(x, times: n)
          |> list.append(group_by_duplicate(list_without_current))
      }
      data
    }
  }
}

// Calculate the lowest price. 
// The group is the current combinaison to calculate. 
// It will decrease at every loop. 
fn calculate_price(books: List(Int), group: Int) -> Float {
  let uniques =
    list.unique(books)
    |> list.take(group)

  case list.length(uniques) {
    x if x < 2 -> {
      books
      |> list.length
      |> int.to_float
      |> float.multiply(800.0)
    }
    x ->
      remove_group(books, uniques)
      |> fn(b) { calculate_price(b, list.length(list.unique(b))) }
      |> float.add(get_book_price_with_discount(x))
      |> float.min(calculate_price(books, group - 1))
  }
}

pub fn lowest_price(books: List(Int)) -> Float {
  list.map(books, fn(x) { x * 100 })
  |> group_by_duplicate
  |> fn(b) { calculate_price(b, list.length(list.unique(b))) }
}
