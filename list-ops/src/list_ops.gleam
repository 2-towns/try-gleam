pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  case first {
    [x, ..rest] -> [x, ..append(rest, second)]
    [] -> second
  }
}

fn concat_tail(lists: List(List(a)), acc: List(a)) {
  case lists {
    [x, ..rest] -> concat_tail(rest, append(acc, x))
    [] -> acc
  }
}

pub fn concat(lists: List(List(a))) -> List(a) {
  concat_tail(lists, [])
}

fn filter_tail(list: List(a), function: fn(a) -> Bool, acc: List(a)) {
  case list {
    [x, ..rest] -> {
      case function(x) {
        True -> filter_tail(rest, function, append(acc, [x]))
        False -> filter_tail(rest, function, acc)
      }
    }
    [] -> acc
  }
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  filter_tail(list, function, [])
}

fn length_tail(list: List(a), sum: Int) {
  case list {
    [_, ..rest] -> length_tail(rest, 1 + sum)
    [] -> sum
  }
}

pub fn length(list: List(a)) -> Int {
  length_tail(list, 0)
}

fn map_tail(list: List(a), function: fn(a) -> b, acc: List(b)) -> List(b) {
  case list {
    [x, ..rest] -> map_tail(rest, function, append(acc, [function(x)]))
    [] -> acc
  }
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  map_tail(list, function, [])
}

fn foldl_tail(over: List(a), with: fn(b, a) -> b, acc: b) {
  case over {
    [x, ..rest] -> foldl_tail(rest, with, with(acc, x))
    [] -> acc
  }
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  foldl_tail(list, function, initial)
}

fn foldr_tail(over: List(a), with: fn(b, a) -> b, acc: b) {
  case over {
    [x, ..rest] -> foldr_tail(rest, with, with(acc, x))
    [] -> acc
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  foldl(reverse(list), initial, function)
}

fn reverse_tail(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [x, ..rest] -> reverse_tail(rest, [x, ..acc])
    [] -> acc
  }
}

pub fn reverse(list: List(a)) -> List(a) {
  reverse_tail(list, [])
}
