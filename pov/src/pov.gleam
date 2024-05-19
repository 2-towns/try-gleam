import gleam/dict.{type Dict}
import gleam/list
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

type TreeReverse(a) {
  TreeReverse(label: a, children: List(Tree(a)), parent: Result(Tree(a), Nil))
}

fn build_parents(parent: Tree(a)) -> Dict(a, TreeReverse(a)) {
  dict.from_list(
    list.map(parent.children, fn(current) {
      #(current.label, TreeReverse(current.label, current.children, Ok(parent)))
    }),
  )
  |> dict.merge(
    list.fold(parent.children, dict.new(), fn(acc, child) {
      dict.merge(acc, build_parents(child))
    }),
  )
}

fn extract_parent(tree: TreeReverse(a), parents: Dict(a, TreeReverse(a))) {
  case tree.parent {
    Error(_) -> Error(Nil)
    Ok(parent) -> dict.get(parents, parent.label)
  }
}

fn reparent(tree: TreeReverse(a), parents: Dict(a, TreeReverse(a))) {
  extract_parent(tree, parents)
  |> result.try(fn(parent) {
    reparent(
      TreeReverse(
        ..parent,
        children: list.filter(parent.children, fn(child) {
          child.label != tree.label
        }),
      ),
      parents,
    )
    |> result.map(fn(result) { [result] })
    |> result.map(fn(children) {
      Tree(tree.label, list.append(tree.children, children))
    })
  })
  |> result.try_recover(fn(_) { Ok(Tree(tree.label, tree.children)) })
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  case tree.children {
    [] if tree.label == from -> Ok(tree)
    [] -> Error(Nil)
    _ -> {
      let parents =
        build_parents(tree)
        |> dict.merge(
          dict.from_list([
            #(tree.label, TreeReverse(tree.label, tree.children, Error(Nil))),
          ]),
        )

      case dict.get(parents, from) {
        Error(_) -> Error(Nil)
        Ok(x) -> reparent(x, parents)
      }
    }
  }
}

fn go_through(tree: Tree(a), to: a) -> Result(List(a), Nil) {
  case tree {
    Tree(label, _) if to == label -> Ok([label])
    Tree(label, []) if to != label -> Error(Nil)
    Tree(label, children) ->
      Ok(
        list.fold(children, [label], fn(acc, child) {
          go_through(child, to)
          |> result.map(fn(paths) { list.append(acc, paths) })
          |> result.unwrap(acc)
        }),
      )
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  let value =
    from_pov(tree, from)
    |> result.try(fn(p) { go_through(p, to) })

  case
    value
    |> result.unwrap([])
    |> list.contains(to)
  {
    True -> value
    False -> Error(Nil)
  }
}
