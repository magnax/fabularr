# frozen_string_literal: true

recipes_created = 0
recipes_updated = 0
instructions_created = 0
instructions_updated = 0

definitions = Definitions::Recipes::RECIPES + Definitions::Recipes::Machinery::RECIPES

definitions.each do |recipe_definition| # rubocop:disable Metrics/BlockLength
  (key, recipe_type) = recipe_definition[:key].split('#')

  base_speed = recipe_definition[:base_speed]
  base_speed = base_speed.to_i * GameTime::DAY if base_speed&.to_s&.match(/\d{1,2}d/)

  attrs = {
    recipe_type: recipe_type,
    base_speed: base_speed,
    skill: Skill.where(key: recipe_definition[:skill]).first_or_create
  }

  recipe = Recipe.find_by(key: key)
  if recipe
    recipe.update!(attrs)
    recipes_updated += 1
  else
    recipe = Recipe.create!(attrs.merge(key: key))
    recipes_created += 1
  end

  if recipe.recipe_type == Recipe::MACHINERY

    machinery = Machinery.find_by(key: key)
    if machinery
      machinery.update!(
        portable: recipe_definition[:portable] || false,
        placement: recipe_definition[:placement]
      )
    else
      Machinery.create!(
        key: key,
        portable: recipe_definition[:portable] || false,
        placement: recipe_definition[:placement]
      )
    end
  end

  recipe_definition[:instructions].each do |i| # rubocop:disable Metrics/BlockLength
    (i_type, i_key) = i[:key].split('#')
    metadata = nil

    case i_type
    when RecipeInstruction::RESOURCE, RecipeInstruction::RESOURCE_OUT
      subject = Resource.where(key: i_key).first_or_create
    when RecipeInstruction::TOOL
      subject = ItemType.where(key: i_key).first_or_create
    when RecipeInstruction::ITEM
      subject = ItemType.where(key: i_key).first_or_create
      if i[:options]
        subject.update!(virtual: true)
        i[:options].each do |option_item|
          item_type = ItemType.find_by(key: option_item[:key])
          if item_type
            item_type.update!(parent_item_type: subject)
          else
            ItemType.create!(key: option_item[:key], parent_item_type: subject)
          end
        end
      end
    end

    ri_attrs = {
      amount: i[:amount],
      instruction_type: i_type,
      metadata: metadata,
      speed: i[:speed],
      unit: i[:unit] || 'grams'
    }

    rinstr = RecipeInstruction.find_by(recipe_id: recipe.id, subject: subject)
    if rinstr
      rinstr.update!(ri_attrs)
      instructions_updated += 1
    else
      RecipeInstruction.create!(
        ri_attrs.merge(recipe_id: recipe.id, subject: subject)
      )
      instructions_created += 1
    end
  end

  if recipe_definition[:machine].present?
    subject = Machinery.where(key: recipe_definition[:machine]).first_or_create

    ri_attrs = {
      recipe_id: recipe.id,
      subject: subject,
      instruction_type: RecipeInstruction::MACHINERY

    }
    rinstr = RecipeInstruction.find_by(ri_attrs)

    if rinstr
      instructions_updated += 1
    else
      RecipeInstruction.create!(ri_attrs)
      instructions_created += 1
    end
  end

  if recipe_definition[:max_amount].present?
    ri_attrs = {
      recipe_id: recipe.id,
      subject: nil,
      instruction_type: RecipeInstruction::MAX_AMOUNT

    }
    rinstr = RecipeInstruction.find_by(ri_attrs)

    if rinstr
      rinstr.update!(amount: recipe[:max_amount])
      instructions_updated += 1
    else
      RecipeInstruction.create!(ri_attrs.merge(amount: recipe[:max_amount]))
      instructions_created += 1
    end
  end

  next if recipe_definition[:placement].blank?

  ri_placement_attrs = {
    recipe_id: recipe.id,
    subject: nil,
    instruction_type: RecipeInstruction::PLACEMENT

  }
  rinstr = RecipeInstruction.find_by(ri_placement_attrs)

  if rinstr
    rinstr.update!(metadata: { placement: [recipe_definition[:placement]] })
    instructions_updated += 1
  else
    RecipeInstruction.create!(
      ri_placement_attrs.merge(metadata: { placement: [recipe_definition[:placement]] })
    )
    instructions_created += 1
  end
end

Log.say "Recipes: created #{recipes_created}, updated #{recipes_updated}"
Log.say "Instructions: created #{instructions_created}, updated #{instructions_updated}"
Log.say "All recipes: #{Recipe.all.pluck(:key).join(', ')}"
