data:extend(
{
  {
    type = "logistic-container",
    name = "logistic-chest-storage2",
    icon = "__base__/graphics/icons/logistic-chest-storage.png",
    flags = {"not-on-map"},
    max_health = 0,
    items_to_place_this = "logistic-chest-storage2",
    collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
    selection_box = {{-0.0, -0.0}, {0.0, 0.0}},
	 fast_replaceable_group =  "",
    inventory_size = 48,
    logistic_mode = "passive-provider",
    picture =
    {
      filename = "__smarter_chests__/graphics/logistic-chest-hybrid.png",
      priority = "extra-high",
      width = 38,
      height = 32,
      shift = {0.1, 0}
    },
    circuit_wire_max_distance = 1,
  },
  {
    type = "logistic-container",
    name = "logistic-chest-storage2-ui",
    icon = "__base__/graphics/icons/logistic-chest-storage.png",
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "logistic-chest-storage2-ui"},
    max_health = 150,
    corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	 fast_replaceable_group =  "container",
    inventory_size = 48,
    logistic_mode = "requester",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = "__smarter_chests__/graphics/logistic-chest-hybrid.png",
      priority = "extra-high",
      width = 38,
      height = 32,
      shift = {0.1, 0.0}
    },
    circuit_wire_max_distance = 7.5,
  },
}
)
