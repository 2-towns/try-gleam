import gleam/result

fn is_in_circle(x: Float, y: Float, radius: Float) {
  case { x *. x +. y *. y } <=. radius *. radius {
    True -> Ok(True)
    False -> Error(Nil)
  }
}

pub fn score(x: Float, y: Float) -> Int {
  is_in_circle(x, y, 1.0)
  |> result.map(fn(_) { 10 })
  |> result.try_recover(fn(_) {
    is_in_circle(x, y, 5.0)
    |> result.map(fn(_) { 5 })
  })
  |> result.try_recover(fn(_) {
    is_in_circle(x, y, 10.0)
    |> result.map(fn(_) { 1 })
  })
  |> result.unwrap(0)
}
