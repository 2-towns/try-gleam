import gleam/string
import gleam/io
import gleam/list
import gleam/result

pub fn first_letter(name: String) -> String {
  string.trim(name)
  |> string.first
  |> result.unwrap("")
}

pub fn initial(name: String) {
  first_letter(name)
  |> string.uppercase
  |> string.append(".")
}

pub fn initials(full_name: String) -> String {
  string.split(full_name, " ")
  |> list.map(fn(name) { initial(name) })
  |> list.reduce(fn(acc, name) { acc <> " " <> name })
  |> result.unwrap("")
}

pub fn pair(full_name1: String, full_name2: String) {
  let i = initials(full_name1) <> "  +  " <> initials(full_name2)

  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     " <> i <> "     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
}

pub fn main() {
  pair("Arnaud Deville", "Fatima Bouzar")
  |> io.print
}
