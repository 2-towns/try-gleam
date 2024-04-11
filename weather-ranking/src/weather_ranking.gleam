import gleam/order.{type Order}
import gleam/float
import gleam/list

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub fn fahrenheit_to_celsius(f: Float) -> Float {
  { f -. 32.0 } /. 1.8
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
  case left, right {
    Celsius(x), Celsius(y) -> float.compare(x, y)
    Fahrenheit(x), Celsius(y) -> float.compare(fahrenheit_to_celsius(x), y)
    Celsius(x), Fahrenheit(y) -> float.compare(x, fahrenheit_to_celsius(y))
    Fahrenheit(x), Fahrenheit(y) -> float.compare(x, y)
  }
}

pub fn compare_city(left: City, right: City) -> Order {
  compare_temperature(left.temperature, right.temperature)
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
  list.sort(cities, by: compare_city)
}
