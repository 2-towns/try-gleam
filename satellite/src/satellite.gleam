import gleam/list
import gleam/result

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

fn check_size(inorder inorder: List(a), preorder preorder: List(a)) {
  case list.length(inorder), list.length(preorder) {
    x, y if x != y -> Error(DifferentLengths)
    _, _ -> Ok(1)
  }
}

fn check_unique(inorder inorder: List(a)) {
  case list.unique(inorder) |> list.length, list.length(inorder) {
    x, y if x != y -> Error(NonUniqueItems)
    _, __ -> Ok(1)
  }
}

fn check_same(inorder inorder: List(a), preorder preorder: List(a)) {
  case
    list.filter(inorder, fn(x) { list.contains(preorder, x) == False })
    |> list.length
  {
    0 -> Ok(1)
    _ -> Error(DifferentItems)
  }
}

fn to_tree(items: List(a)) {
  case items {
    [a, b, ..rest] -> Node(a, Node(b, Nil, Nil), to_tree(rest))
    [a] -> Node(a, Nil, Nil)
    [] -> Nil
  }
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  check_size(inorder, preorder)
  |> result.try(fn(_) { check_same(inorder, preorder) })
  |> result.try(fn(_) { check_unique(inorder) })
  |> result.map(fn(_) { to_tree(preorder) })
}
