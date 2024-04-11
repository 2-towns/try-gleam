import gleam/list
import gleam/string

pub type Student {
  Alice
  Bob
  Charlie
  David
  Eve
  Fred
  Ginny
  Harriet
  Ileana
  Joseph
  Kincaid
  Larry
}

pub type Plant {
  Radishes
  Clover
  Violets
  Grass
}

fn get_student_index(student: Student) {
  case student {
    Alice -> 0
    Bob -> 1
    Charlie -> 2
    David -> 3
    Eve -> 4
    Fred -> 5
    Ginny -> 6
    Harriet -> 7
    Ileana -> 8
    Joseph -> 9
    Kincaid -> 10
    Larry -> 11
  }
}

fn get_plants_from_graphites(graphites: List(String)) -> List(Plant) {
  case graphites {
    ["R", ..rest] -> [Radishes, ..get_plants_from_graphites(rest)]
    ["C", ..rest] -> [Clover, ..get_plants_from_graphites(rest)]
    ["V", ..rest] -> [Violets, ..get_plants_from_graphites(rest)]
    ["G", ..rest] -> [Grass, ..get_plants_from_graphites(rest)]
    [_, ..rest] -> get_plants_from_graphites(rest)
    [] -> []
  }
}

fn get_plants_per_row(rows: List(String), index: Int) -> List(Plant) {
  case rows {
    [x, ..rest] ->
      string.slice(x, at_index: index, length: 2)
      |> string.to_graphemes
      |> get_plants_from_graphites
      |> fn(plants) { list.concat([plants, get_plants_per_row(rest, index)]) }
    [] -> []
  }
}

pub fn plants(diagram: String, student: Student) -> List(Plant) {
  let rows =
    string.split(diagram, "\n")
    |> get_plants_per_row(get_student_index(student) * 2)
}
