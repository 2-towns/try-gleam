import gleam/io
import gleam/dict.{type Dict}
import gleam/order
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/list
import gleam/int

type Team {
  Team(
    name: String,
    played: Int,
    wins: Int,
    draws: Int,
    losses: Int,
    points: Int,
  )
}

const spaces = 31

fn concat(current: Option(String), value: String) {
  case current {
    Some(x) -> x <> value
    None -> value
  }
}

fn parse_line(line: String, teams: Dict(String, String)) {
  let parts = string.split(line, ";")
  case parts {
    [a, b, "win"] ->
      dict.update(teams, a, fn(x) { concat(x, "W") })
      |> dict.update(b, fn(x) { concat(x, "L") })
    [a, b, "loss"] ->
      dict.update(teams, a, fn(x) { concat(x, "L") })
      |> dict.update(b, fn(x) { concat(x, "W") })
    [a, b, "draw"] ->
      dict.update(teams, a, fn(x) { concat(x, "D") })
      |> dict.update(b, fn(x) { concat(x, "D") })
    _ -> teams
  }
}

fn parse_lines(lines: List(String), teams: Dict(String, String)) {
  case lines {
    [x] -> parse_line(x, teams)
    [x, ..rest] ->
      parse_line(x, teams)
      |> parse_lines(rest, _)
    [] -> teams
  }
}

fn count_occurences(value: List(String), letter: String) {
  list.filter(value, fn(x) { x == letter })
  |> list.length
}

fn calculate_points(value: List(String)) {
  case value {
    ["W", ..rest] -> 3 + calculate_points(rest)
    ["D", ..rest] -> 1 + calculate_points(rest)
    [_, ..rest] -> calculate_points(rest)
    [] -> 0
  }
}

fn pad_data(data: Int) {
  let s = int.to_string(data)
  case data {
    x if x >= 100 -> s
    x if x >= 10 -> " " <> s
    _ -> "  " <> s
  }
}

fn team_to_string(team: Team) {
  team.name
  |> string.pad_right(with: " ", to: spaces)
  |> string.append("|" <> pad_data(team.played) <> " ")
  |> string.append("|" <> pad_data(team.wins) <> " ")
  |> string.append("|" <> pad_data(team.draws) <> " ")
  |> string.append("|" <> pad_data(team.losses) <> " ")
  |> string.append("|" <> pad_data(team.points))
}

fn team_compare(a: Team, b: Team) {
  case a, b {
    x, y if x.points > y.points -> order.Lt
    x, y if x.points < y.points -> order.Gt
    x, y -> string.compare(x.name, y.name)
  }
}

fn to_teams(teams: Dict(String, String)) {
  dict.map_values(teams, fn(key, value) {
    let graphemes = string.to_graphemes(value)
    Team(
      key,
      list.length(graphemes),
      count_occurences(graphemes, "W"),
      count_occurences(graphemes, "D"),
      count_occurences(graphemes, "L"),
      calculate_points(graphemes),
    )
  })
  |> dict.values
  |> list.sort(team_compare)
}

pub fn tally(input: String) -> String {
  string.split(input, "\n")
  |> parse_lines(dict.new())
  |> to_teams
  |> list.fold("", fn(acc, value) { acc <> "\n" <> team_to_string(value) })
  |> string.append("Team                           | MP |  W |  D |  L |  P", _)
}

pub fn main() {
  tally("Blithering Badgers;Allegoric Alaskans;loss")
  |> io.print
}
