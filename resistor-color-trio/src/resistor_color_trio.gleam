import gleam/dict 

pub type Resistance {
  Resistance(unit: String, value: Int)
}

const values = [
  #("black", 0), 
  #("brown", 1), 
  #("red", 2 ) , 
  #("orange", 3) , 
  #("yellow",4), 
  #("green", 5), 
  #("blue", 6), 
  #("violet", 7), 
  #("grey", 8 ) ,
  #("white", 9) 
]

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  let v = dict.from_list(values) 
    case colors {
[x, ..rest] -> 
    [] ->  values.get(x) +   
  }
const values = dict.from_list(
[]
)
p
  todo
}
