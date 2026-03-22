# frozen_string_literal: true

Definitions::Recipes::RECIPES.each do |recipe|
  ItemType.where(key: recipe[:key]).first_or_create
  r = Recipe.where(key: recipe[:key])
            .first_or_create(base_speed: recipe[:base_speed])
  recipe[:instructions].each do |i|
    next unless i[:type] == 'resource'

    res = Resource.where(key: i[:key]).first_or_create
    RecipeInstruction.create!(
      recipe_id: r.id, subject: res, amount: i[:amount], unit: 'grams'
    )
  end
end
