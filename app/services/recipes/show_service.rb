# frozen_string_literal: true

module Recipes
  class ShowService < ApplicationService
    def call
      {
        recipes: recipes,
        project_type_id: ProjectType.find_by(key: 'build')
      }
    end

    private

    def recipes
      @recipes ||= Recipe.by_type(Recipe::BUILD_TYPES).map do |recipe|
        recipe_instructions = recipe.recipe_instructions
        {
          id: recipe.id,
          resource_instructions: recipe_instructions.resource,
          tool_instructions: recipe_instructions.tool,
          placement_instructions: recipe_instructions.placement,
          item_instructions: item_instructions(
            recipe_instructions.item + recipe_instructions.option_item
          ),
          key: recipe.key,
          recipe_type: I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}").downcase,
          time_needed: TimeService.display_time(recipe.base_speed)
        }
      end
    end

    def item_instructions(instructions)
      instructions.map do |instruction|
        if instruction.instruction_type == RecipeInstruction::OPTION_ITEM

          {
            options: instruction.metadata.map do |item_id|
              {
                id: item_id,
                key: ItemType.find_by(id: item_id).key
              }
            end
          }
        else
          { key: instruction.subject.key }
        end
      end
    end
  end
end
