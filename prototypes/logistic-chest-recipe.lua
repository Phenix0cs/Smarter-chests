data:extend(
{
  {
    type = "recipe",
    name = "logistic-chest-storage2-ui",
    enabled = false,
    ingredients = data.raw["recipe"]["logistic-chest-storage"].ingredients,
    result = "logistic-chest-storage2-ui"
  },
}
)


table.insert(data.raw["technology"]["logistic-system"].effects,
{type = "unlock-recipe", recipe = "logistic-chest-storage2-ui"})
