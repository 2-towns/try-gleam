import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Forth {
  Forth(record: List(String), definitions: dict.Dict(String, List(String)))
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  Forth([], dict.new())
}

pub fn format_stack(f: Forth) -> String {
  string.join(f.record, " ") |> string.trim
}

fn parse_numbers(x: String, y: String) {
  case int.parse(x), int.parse(y) {
    Ok(a), Ok(b) -> Ok(#(a, b))
    _, _ -> Error(StackUnderflow)
  }
}

fn apply_operation(tuple: #(Int, Int), op: String) {
  case op {
    "+" -> Ok(tuple.1 + tuple.0)
    "-" -> Ok(tuple.1 - tuple.0)
    "*" -> Ok(tuple.1 * tuple.0)
    "/" -> {
      case tuple.0 {
        0 -> Error(DivisionByZero)
        x -> Ok(tuple.1 / x)
      }
    }
    _ -> Error(UnknownWord)
  }
}

fn eval_operation(f: Forth, op: String) -> Result(List(String), ForthError) {
  case f.record |> list.reverse {
    [] -> Error(StackUnderflow)
    [_] -> Error(StackUnderflow)
    [x, y, ..rest] ->
      parse_numbers(x, y)
      |> result.try(apply_operation(_, op))
      |> result.map(int.to_string)
      |> result.map(fn(res) { list.append(rest |> list.reverse, [res]) })
  }
}

fn eval_stack_operation(
  f: Forth,
  op: String,
) -> Result(List(String), ForthError) {
  case f.record |> list.reverse, op {
    [], _ -> Error(StackUnderflow)
    [x, ..rest], "DUP" -> Ok(list.append(rest, [x, x]))
    [_, ..rest], "DROP" -> Ok(rest |> list.reverse)
    [x, y, ..rest], "SWAP" -> Ok(list.append(rest |> list.reverse, [x, y]))
    [_, ..], "SWAP" -> Error(StackUnderflow)
    [x, y, ..rest], "OVER" -> Ok(list.append(rest |> list.reverse, [y, x, y]))
    [_, ..], "OVER" -> Error(StackUnderflow)
    _, _ -> Error(UnknownWord)
  }
}

fn get_custom_definition(expr: List(String)) {
  list.take_while(expr, fn(x) { x != ";" })
}

fn drop_custom_definition(expr: List(String)) {
  list.drop_while(expr, fn(x) { x != ";" })
  |> list.drop(1)
  |> string.join(" ")
}

fn eval_custom_definition(
  f: Forth,
  op: String,
  expr: List(String),
) -> Result(Forth, ForthError) {
  eval(f, get_custom_definition(expr) |> string.join(" "))
  |> result.map(fn(x) {
    Forth(f.record, dict.insert(f.definitions, op, x.record))
  })
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let parts = string.uppercase(prog) |> string.split(" ")
  case parts, list.first(parts) |> result.try(dict.get(f.definitions, _)) {
    [], _ -> Ok(f)
    [""], _ -> Ok(f)
    [":", op, ..rest], _ ->
      case int.parse(op) {
        Ok(_) -> Error(InvalidWord)
        Error(_) -> {
          eval_custom_definition(f, op, rest)
          |> result.try_recover(fn(_) {
            Ok(Forth(
              f.record,
              dict.insert(f.definitions, op, get_custom_definition(rest)),
            ))
          })
          |> result.try(fn(x) { eval(x, drop_custom_definition(rest)) })
        }
      }
    [_, ..rest], Ok(ops) ->
      list.try_fold(ops, f, fn(acc, op) { eval(acc, op) })
      |> result.try(eval(_, string.join(rest, " ")))
    [op, ..rest], _ if op == "+" || op == "-" || op == "*" || op == "/" ->
      eval_operation(f, op)
      |> result.try(fn(r) {
        eval(Forth(r, f.definitions), string.join(rest, " "))
      })
    [op, ..rest], _
      if op == "DUP" || op == "DROP" || op == "SWAP" || op == "OVER"
    ->
      eval_stack_operation(f, op)
      |> result.try(fn(r) {
        eval(Forth(r, f.definitions), string.join(rest, " "))
      })
    [x, ..rest], _ -> {
      int.parse(x)
      |> result.map_error(fn(_) { UnknownWord })
      |> result.try(fn(_) {
        eval(
          Forth(list.append(f.record, [x]), f.definitions),
          string.join(rest, " "),
        )
      })
    }
  }
}
