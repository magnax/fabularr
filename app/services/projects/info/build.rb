# frozen_string_literal: true

module Projects
  class Info::Build < ApplicationService
    class InvalidPlacementError < StandardError; end

    def initialize(character, recipe_id)
      @character = character
      @recipe_id = recipe_id
    end

    def call
      raise InvalidPlacementError if invalid_placement?

      {
        item_name: item_name,
        placement: placement_key,
        project_type_id: project_type.id,
        recipe_id: @recipe_id,
        time_needed: time_needed
      }
    end

    private

    def invalid_placement?
      false
    end

    def item_name
      @item_name ||= I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}")
    end

    def placement_key
      return 'outside_all' if vehicle?

      nil
    end

    def vehicle?
      recipe.recipe_type == Recipe::VEHICLE
    end

    def time_needed
      TimeService.display_time(recipe.base_speed)
    end

    def project_type
      @project_type ||= ProjectType.find_by(key: 'build')
    end

    def recipe
      @recipe ||= Recipe.find_by(id: @recipe_id)
    end
  end
end
