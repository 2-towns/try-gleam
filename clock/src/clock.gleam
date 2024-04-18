import gleam/int
import gleam/io

pub type Clock {
  Clock(hour: Int, minute: Int)
}

pub fn calculate_time(hour: Int, minute: Int) {
  case hour, minute {
    x, _ if x < 0 -> calculate_time(hour + 24, minute)
    _, y if y < 0 -> calculate_time(hour - 1, minute + 60)
    _, y if y >= 60 -> calculate_time(hour + 1, minute - 60)
    x, _ -> {
      #(x % 24, minute)
    }
  }
}

pub fn create(hour hour: Int, minute minute: Int) -> Clock {
  let #(hours, minutes) = calculate_time(hour, minute)
  Clock(hours, minutes)
}

pub fn add(clock: Clock, minutes minutes: Int) -> Clock {
  let #(hour, minute) = calculate_time(clock.hour, clock.minute + minutes)
  Clock(hour, minute)
}

pub fn subtract(clock: Clock, minutes minutes: Int) -> Clock {
  let #(hour, minute) = calculate_time(clock.hour, clock.minute - minutes)
  Clock(hour, minute)
}

pub fn display(clock: Clock) -> String {
  let h = case clock.hour {
    hour if hour < 10 -> "0" <> int.to_string(hour)
    hour -> int.to_string(hour)
  }

  let m = case clock.minute {
    minute if minute < 10 -> "0" <> int.to_string(minute)
    minute -> int.to_string(minute)
  }

  h <> ":" <> m
}

pub fn main() {
  create(hour: 0, minute: 45)
  |> add(minutes: 160)
  |> display
  |> io.debug
}
