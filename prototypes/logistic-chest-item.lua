data:extend(
{
  {
    type = "item",
    name = "logistic-chest-storage2",
    icon = "__base__/graphics/icons/logistic-chest-storage.png",
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
    icon = "__base__/graphics/icons/logistic-chest-storage.png",
    flags = {"goes-to-quickbar"},
    subgroup = "logistic-network",
    order = "b[storage]-c[logistic-chest-storage]-d",
    place_result = "logistic-chest-storage2-ui",
    stack_size = 50
  },
}
)

