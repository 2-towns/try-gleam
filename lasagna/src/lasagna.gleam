const minutes_per_layer = 2

pub fn expected_minutes_in_oven() -> Int {
  40
}

pub fn remaining_minutes_in_oven(completed: Int) -> Int {
  expected_minutes_in_oven() - completed
}

pub fn preparation_time_in_minutes(layer: Int) -> Int {
  layer * minutes_per_layer
}

pub fn total_time_in_minutes(layer: Int, completed: Int) -> Int {
  preparation_time_in_minutes(layer) + completed
}

pub fn alarm() -> String {
  "Ding!"
}
