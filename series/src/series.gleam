import gleam/string

fn slices_tail(input: String, size: Int, index: Int) {
  let sliced = string.slice(input, at_index: index, length: size)
  case string.length(sliced) {
    x if x == size -> [sliced, ..slices_tail(input, size, index + 1)]
    _ -> []
  }
}

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case string.length(input) {
    x if x == 0 -> Error(EmptySeries)
    _ if size == 0 -> Error(SliceLengthZero)
    _ if size < 0 -> Error(SliceLengthNegative)
    x if x < size -> Error(SliceLengthTooLarge)
    _ -> Ok(slices_tail(input, size, 0))
  }
}

pub type Error {
  SliceLengthTooLarge
  SliceLengthZero
  SliceLengthNegative
  EmptySeries
}
