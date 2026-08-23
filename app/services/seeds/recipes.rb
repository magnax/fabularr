# frozen_string_literal: true

module Seeds
  class Recipes < ApplicationService
    def initialize
      @recipes_created = 0
      @recipes_updated = 0
      @instructions_created = 0
      @instructions_updated = 0
    end

    def call
      definitions.each do |recipe_definition|
        (key, recipe_type) = recipe_definition[:key].split('#')

        recipe = create_recipe!(key, recipe_type, recipe_definition)

        create_machinery!(recipe, recipe_definition)

        recipe_definition[:instructions].each do |definition|
          create_recipe_instruction_with_subjects!(recipe, definition)
        end

        create_machinery_instruction!(recipe, recipe_definition)
        create_max_amount_instruction!(recipe, recipe_definition)
        create_placement_instruction!(recipe, recipe_definition)
      end

      log!
    end

    private

    def definitions
      @definitions ||= Definitions::Recipes::RECIPES +
                       Definitions::Recipes::Machinery::RECIPES
    end

    def create_recipe!(key, recipe_type, recipe_definition)
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
        @recipes_updated += 1
      else
        recipe = Recipe.create!(attrs.merge(key: key))
        @recipes_created += 1
      end

      recipe
    end

    def create_recipe_instruction_with_subjects!(recipe, definition)
      (i_type, i_key) = definition[:key].split('#')

      case i_type
      when RecipeInstruction::RESOURCE, RecipeInstruction::RESOURCE_OUT
        subject = Resource.where(key: i_key).first_or_create
      when RecipeInstruction::TOOL
        subject = create_tool_instruction_subject!(i_key, definition)
      when RecipeInstruction::ITEM
        subject = create_item_instruction_subject!(i_key, definition)
      end

      create_recipe_instruction!(recipe, definition, i_type, subject)
    end

    def create_tool_instruction_subject!(key, definition)
      subject = ItemType.where(key: key).first_or_create
      return subject unless definition[:options]

      subject.update!(virtual: true)
      definition[:options].each do |option_item|
        item_type = ItemType.find_by(key: option_item[:key])
        if item_type
          item_type.update!(parent_item_type: subject)
        else
          ItemType.create!(key: option_item[:key], parent_item_type: subject)
        end
      end

      subject
    end

    def create_item_instruction_subject!(key, definition)
      subject = ItemType.where(key: key).first_or_create
      return subject unless definition[:options]

      subject.update!(virtual: true)
      definition[:options].each do |option_item|
        item_type = ItemType.find_by(key: option_item[:key])
        if item_type
          item_type.update!(parent_item_type: subject)
        else
          ItemType.create!(key: option_item[:key], parent_item_type: subject)
        end
      end

      subject
    end

    def create_recipe_instruction!(recipe, definition, i_type, subject)
      attrs = {
        amount: definition[:amount],
        instruction_type: i_type,
        metadata: nil,
        speed: definition[:speed],
        unit: definition[:unit] || 'grams'
      }

      rinstr = RecipeInstruction.find_by(recipe_id: recipe.id, subject: subject)
      if rinstr
        rinstr.update!(attrs)
        @instructions_updated += 1
      else
        RecipeInstruction.create!(
          attrs.merge(recipe_id: recipe.id, subject: subject)
        )
        @instructions_created += 1
      end
    end

    def create_machinery_instruction!(recipe, recipe_definition)
      return if recipe_definition[:machine].blank?

      subject = Machinery.where(key: recipe_definition[:machine]).first_or_create

      ri_attrs = {
        recipe_id: recipe.id,
        subject: subject,
        instruction_type: RecipeInstruction::MACHINERY

      }
      rinstr = RecipeInstruction.find_by(ri_attrs)

      if rinstr
        @instructions_updated += 1
      else
        RecipeInstruction.create!(ri_attrs)
        @instructions_created += 1
      end
    end

    def create_max_amount_instruction!(recipe, recipe_definition)
      return if recipe_definition[:max_amount].blank?

      ri_attrs = {
        recipe_id: recipe.id,
        subject: nil,
        instruction_type: RecipeInstruction::MAX_AMOUNT

      }
      rinstr = RecipeInstruction.find_by(ri_attrs)

      if rinstr
        rinstr.update!(amount: recipe[:max_amount])
        @instructions_updated += 1
      else
        RecipeInstruction.create!(ri_attrs.merge(amount: recipe[:max_amount]))
        @instructions_created += 1
      end
    end

    def create_placement_instruction!(recipe, recipe_definition)
      return if recipe_definition[:placement].blank?

      ri_placement_attrs = {
        recipe_id: recipe.id,
        subject: nil,
        instruction_type: RecipeInstruction::PLACEMENT

      }
      rinstr = RecipeInstruction.find_by(ri_placement_attrs)

      if rinstr
        rinstr.update!(metadata: { placement: [recipe_definition[:placement]] })
        @instructions_updated += 1
      else
        RecipeInstruction.create!(
          ri_placement_attrs.merge(metadata: { placement: [recipe_definition[:placement]] })
        )
        @instructions_created += 1
      end
    end

    def create_machinery!(recipe, recipe_definition)
      return unless recipe.recipe_type == Recipe::MACHINERY

      machinery = Machinery.find_by(key: recipe.key)
      if machinery
        machinery.update!(
          portable: recipe_definition[:portable] || false,
          placement: recipe_definition[:placement]
        )
      else
        Machinery.create!(
          key: recipe.key,
          portable: recipe_definition[:portable] || false,
          placement: recipe_definition[:placement]
        )
      end
    end

    def log!
      Log.say "Recipes: created #{@recipes_created}, updated #{@recipes_updated}"
      Log.say "Instructions: created #{@instructions_created}, updated #{@instructions_updated}"
      Log.say "All recipes: #{Recipe.all.pluck(:key).join(', ')}"
    end
  end
end
