fn max_bit_value(number: Int, accumulator: Int) -> Int {
  case number {
    0 -> accumulator
    _ if accumulator >= number -> accumulator
    _ -> max_bit_value(number, accumulator * accumulator)
  }
}

fn egg_count_loop(number: Int, bit_value: Int) -> Int {
  case number {
    0 -> 0
    _ if number >= bit_value ->
      1 + egg_count_loop(number - bit_value, bit_value / 2)
    _ -> egg_count_loop(number, bit_value / 2)
  }
}

pub fn egg_count(number: Int) -> Int {
  let max_value = max_bit_value(number, 2)
  egg_count_loop(number, max_value)
}
