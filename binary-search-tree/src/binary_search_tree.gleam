import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

fn add_node(tree: Tree, data: Int) {
  case tree {
    Nil -> Node(data, Nil, Nil)
    Node(x, Nil, right) if data <= x -> Node(x, Node(data, Nil, Nil), right)
    Node(x, left, right) if data <= x -> Node(x, add_node(left, data), right)
    Node(x, left, Nil) if data > x -> Node(x, left, Node(data, Nil, Nil))
    Node(x, left, right) -> Node(x, left, add_node(right, data))
  }
}

fn to_tree_loop(data: List(Int), tree: Tree) -> Tree {
  case data {
    [x, ..rest] ->
      add_node(tree, x)
      |> to_tree_loop(rest, _)
    [] -> tree
  }
}

pub fn to_tree(data: List(Int)) -> Tree {
  to_tree_loop(data, Nil)
}

fn sort_tree(tree: Tree) -> List(Int) {
  case tree {
    Node(x, left, right) ->
      list.concat([sort_tree(left), [x], sort_tree(right)])
    Nil -> []
  }
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  to_tree(data)
  |> sort_tree
}
