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
        machineries: machineries,
        objects: instructions_map(objects),
        placement: placement_key,
        project_type_id: project_type.id,
        recipe_id: @recipe_id,
        resources: instructions_map(resources),
        time_needed: time_needed,
        tools: tools
      }
    end

    private

    def invalid_placement?
      false
    end

    def item_name
      @item_name ||= I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}")
    end

    def machineries
      []
    end

    def objects
      []
    end

    def resources
      @resources ||= recipe_instructions.resource
    end

    def tools
      @tools ||= recipe_instructions.tool
    end

    def instructions_map(instructions)
      instructions.map do |res|
        {
          key: res.subject.key,
          amount: res.amount,
          unit: res.unit
        }
      end
    end

    def placement_key
      return 'outside_all' if vehicle?
      return if placement.blank?

      placement.metadata['placement']
    end

    def placement
      @placement ||= recipe_instructions.placement&.first
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

    def recipe_instructions
      @recipe_instructions ||= recipe.recipe_instructions
    end

    def recipe
      @recipe ||= Recipe.find_by(id: @recipe_id)
    end
  end
end
