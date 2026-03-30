# frozen_string_literal: true

Definitions::Recipes::RECIPES.each do |recipe| # rubocop:disable Metrics/BlockLength
  case recipe[:type]
  when 'build'
    ItemType.where(key: recipe[:key]).first_or_create
    r = Recipe.where(key: recipe[:key])
              .first_or_create(recipe_type: 'build', base_speed: recipe[:base_speed])
    recipe[:instructions].each do |i|
      case i[:type]
      when 'resource'
        res = Resource.where(key: i[:key]).first_or_create
        RecipeInstruction.create!(
          recipe_id: r.id, subject: res, amount: i[:amount],
          unit: 'grams', instruction_type: RecipeInstruction::RESOURCE
        )
      when 'tool'
        item_type = ItemType.where(key: i[:key]).first_or_create
        RecipeInstruction.create!(
          recipe_id: r.id, subject: item_type,
          instruction_type: RecipeInstruction::TOOL
        )
      end
    end
  when 'collect'
    r = Recipe.where(key: recipe[:key])
              .first_or_create(recipe_type: 'collect')
    recipe[:instructions].each do |i|
      item_type = ItemType.where(key: i[:key]).first_or_create
      r.recipe_instructions.create!(
        subject: item_type,
        instruction_type: RecipeInstruction::TOOL,
        speed: i[:speed]
      )
    end
  when 'building'
    r = Recipe.where(key: recipe[:key])
              .first_or_create(recipe_type: 'building', base_speed: recipe[:base_speed])
    recipe[:instructions].each do |i|
      res = Resource.where(key: i[:key]).first_or_create
      r.recipe_instructions.create!(
        subject: res,
        instruction_type: RecipeInstruction::RESOURCE,
        unit: 'grams', amount: i[:amount]
      )
    end
  end
end

puts "Created #{Recipe.count} recipes: #{Recipe.all.pluck(:key).join(', ')}"
stone = Resource.find_by(key: 'stone')
wood = Resource.find_by(key: 'wood')
knife = ItemType.find_by(key: 'stone_knife')
Location.find_each do |loc|
  loc.location_objects.create(subject: stone, amount: 500)
  loc.location_objects.create(subject: wood, amount: 500)
  i = Item.create(item_type: knife)
  loc.location_objects.create(subject: i)
end
puts "Added resources & items to locations (#{LocationObject.count} total)"
