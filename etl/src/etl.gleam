import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  dict.fold(legacy, dict.new(), fn(acc, key, value) {
    list.map(value, fn(x) { #(string.lowercase(x), key) })
    |> dict.from_list
    |> dict.merge(acc)
  })
}
