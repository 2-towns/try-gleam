import gleam/list
import gleam/string

pub fn extract_error(problem: Result(a, b)) -> b {
  let assert Error(err) = problem
  err
}

pub fn remove_team_prefix(team: String) -> String {
  let s = string.replace(team, "Team", "")
  string.trim(s)
}

pub fn split_region_and_team(combined: String) -> #(String, String) {
  let l = string.split(combined, ",")
  let assert Ok(left) = list.first(l)
  let assert Ok(rest) = list.rest(l)
  let assert Ok(right) = list.first(rest)
  #(left, remove_team_prefix(right))
}
