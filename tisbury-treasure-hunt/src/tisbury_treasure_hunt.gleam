import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  place_location_to_treasure_location(place_location) == treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  list.filter(treasures, fn(x) {
    treasure_location_matches_place_location(place.1, x.1)
  })
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  let name = desired_treasure.0
  case found_treasure {
    #("Brass Spyglass", _) -> name != "Abandoned Lighthouse"
    #("Amethyst Octopus", _) ->
      { name == "Crystal Crab" || name == "Glass Starfish" }
      && place.0 == "Stormy Breakwater"
    #("Vintage Pirate Hat", _) ->
      place.0 == "Harbor Managers Office"
      && {
        name == "Model Ship in Large Bottle"
        || name == "Antique Glass Fishnet Float"
      }
    _ -> True
  }
}
