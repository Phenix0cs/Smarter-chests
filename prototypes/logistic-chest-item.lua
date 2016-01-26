data:extend(
{
  {
    type = "item",
    name = "logistic-chest-storage2",
    icon = "__smarter_chests__/graphics/logistic-chest-hybrid.png",
    flags = {"hidden"},
    subgroup = "logistic-network",
    place_result = "logistic-chest-storage2-provider",
    order = "",
    place_result = "logistic-chest-storage2",
    stack_size = 50
  },
  {
    type = "item",
    name = "logistic-chest-storage2-ui",
    icon = "__smarter_chests__/graphics/logistic-chest-hybrid.png",
    flags = {"goes-to-quickbar"},
    subgroup = "logistic-network",
    order = "b[storage]-c[logistic-chest-storage]-d",
    place_result = "logistic-chest-storage2-ui",
    stack_size = 50
  },
}
)

