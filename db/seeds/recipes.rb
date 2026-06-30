# frozen_string_literal: true

recipes_created = 0
recipes_updated = 0
instructions_created = 0
instructions_updated = 0

definitions = Definitions::Recipes::RECIPES + Definitions::Recipes::Machinery::RECIPES

definitions.each do |recipe| # rubocop:disable Metrics/BlockLength
  (key, recipe_type) = recipe[:key].split('#')

  attrs = {
    recipe_type: recipe_type,
    base_speed: recipe[:base_speed],
    skill: Skill.where(key: recipe[:skill]).first_or_create
  }

  r = Recipe.find_by(key: key)
  if r
    r.update!(attrs)
    recipes_updated += 1
  else
    r = Recipe.create!(attrs.merge(key: key))
    recipes_created += 1
  end

  recipe[:instructions].each do |i|
    (i_type, i_key) = i[:key].split('#')

    case i_type
    when RecipeInstruction::RESOURCE, RecipeInstruction::RESOURCE_OUT
      subject = Resource.where(key: i_key).first_or_create
    when RecipeInstruction::TOOL
      subject = ItemType.where(key: i_key).first_or_create
    end

    ri_attrs = {
      amount: i[:amount],
      instruction_type: i_type,
      speed: i[:speed],
      unit: i[:unit] || 'grams'
    }

    ri = RecipeInstruction.find_by(recipe_id: r.id, subject: subject)
    if ri
      ri.update!(ri_attrs)
      instructions_updated += 1
    else
      RecipeInstruction.create!(ri_attrs.merge(recipe_id: r.id, subject: subject))
      instructions_created += 1
    end
  end

  if recipe[:machine].present?
    subject = Machinery.where(key: recipe[:machine]).first_or_create

    ri_attrs = {
      recipe_id: r.id,
      subject: subject,
      instruction_type: RecipeInstruction::MACHINERY

    }
    ri = RecipeInstruction.find_by(ri_attrs)

    if ri
      instructions_updated += 1
    else
      RecipeInstruction.create!(ri_attrs)
      instructions_created += 1
    end
  end

  next if recipe[:placement].blank?

  ri_placement_attrs = {
    recipe_id: r.id,
    subject: nil,
    instruction_type: RecipeInstruction::PLACEMENT

  }
  ri = RecipeInstruction.find_by(ri_placement_attrs)

  if ri
    ri.update!(metadata: { placement: [r[:placement]] })
    instructions_updated += 1
  else
    RecipeInstruction.create!(
      ri_placement_attrs.merge(metadata: { placement: [r[:placement]] })
    )
    instructions_created += 1
  end
end

Log.say "Recipes: created #{recipes_created}, updated #{recipes_updated}"
Log.say "Instructions: created #{instructions_created}, updated #{instructions_updated}"
Log.say "All recipes: #{Recipe.all.pluck(:key).join(', ')}"
