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
          key: recipe.key,
          recipe_type: I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}"),
          time_needed: TimeService.display_time(recipe.base_speed)
        }
      end
    end
  end
end
