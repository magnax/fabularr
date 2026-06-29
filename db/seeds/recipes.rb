# frozen_string_literal: true

Definitions::Recipes::RECIPES.each do |recipe|
  (key, recipe_type) = recipe[:key].split('#')

  r = Recipe.where(key: key)
            .first_or_create(
              recipe_type: recipe_type,
              base_speed: recipe[:base_speed],
              skill: Skill.where(key: recipe[:skill]).first_or_create
            )
  recipe[:instructions].each do |i|
    (i_type, i_key) = i[:key].split('#')

    case i_type
    when RecipeInstruction::RESOURCE
      subject = Resource.where(key: i_key).first_or_create
    when RecipeInstruction::TOOL
      subject = ItemType.where(key: i_key).first_or_create
    end
    RecipeInstruction.create!(
      recipe_id: r.id, subject: subject, amount: i[:amount],
      instruction_type: i_type, speed: i[:speed], unit: i[:unit] || 'grams'
    )
  end
  next if recipe[:placement].blank?

  RecipeInstruction.create!(
    recipe_id: r.id,
    subject: nil,
    instruction_type: RecipeInstruction::PLACEMENT,
    metadata: {
      placement: [r[:placement]]
    }
  )
end

Log.say "Created #{Recipe.count} recipes: #{Recipe.all.pluck(:key).join(', ')}"
