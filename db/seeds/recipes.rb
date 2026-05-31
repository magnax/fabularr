# frozen_string_literal: true

Definitions::Recipes::RECIPES.each do |recipe|
  r = Recipe.where(key: recipe[:key])
            .first_or_create(recipe_type: recipe[:type], base_speed: recipe[:base_speed])
  recipe[:instructions].each do |i|
    case i[:type]
    when RecipeInstruction::RESOURCE
      subject = Resource.where(key: i[:key]).first_or_create
    when RecipeInstruction::TOOL
      subject = ItemType.where(key: i[:key]).first_or_create
    end
    RecipeInstruction.create!(
      recipe_id: r.id, subject: subject, amount: i[:amount],
      instruction_type: i[:type], speed: i[:speed], unit: i[:unit] || 'grams'
    )
  end
  next if recipe[:placement].blank?

  RecipeInstruction.create!(
    recipe_id: recipe.id,
    subject: nil,
    instruction_type: RecipeInstruction::PLACEMENT,
    metadata: {
      placement: [recipe[:placement]]
    }
  )
end

Log.say "Created #{Recipe.count} recipes: #{Recipe.all.pluck(:key).join(', ')}"
stone = Resource.find_by(key: 'stone')
wood = Resource.find_by(key: 'wood')
knife = ItemType.find_by(key: 'stone_knife')
Location.find_each do |loc|
  loc.location_objects.create(subject: stone, amount: 500)
  loc.location_objects.create(subject: wood, amount: 500)
  i = Item.create(item_type: knife)
  loc.location_objects.create(subject: i)
end
Log.say "Added resources & items to locations (#{LocationObject.count} total)"
