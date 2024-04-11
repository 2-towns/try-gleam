import gleam/string

pub fn message(log_line: String) -> String {
  case log_line {
    "[ERROR]: " <> rest -> string.trim(rest)
    "[WARNING]: " <> rest -> string.trim(rest)
    "[INFO]: " <> rest -> string.trim(rest)
    _ -> ""
  }
}

pub fn log_level(log_line: String) -> String {
  case log_line {
    "[ERROR]: " <> _ -> "error"
    "[WARNING]: " <> _ -> "warning"
    "[INFO]: " <> _ -> "info"
    _ -> ""
  }
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")"
}
