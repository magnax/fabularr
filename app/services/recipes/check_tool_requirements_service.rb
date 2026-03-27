# frozen_string_literal: true

module Recipes
  class CheckToolRequirementsService < ApplicationService
    def initialize(character, project)
      @character = character
      @project = project
    end

    def call
      return true if recipe.blank? || !build_recipe? || tools_needed.none?

      tools_needed.all? { |tool| tool.subject.key.in?(items_keys) }
    end

    private

    def tools_needed
      @tools_needed ||= recipe.recipe_instructions.tool
    end

    def items_keys
      @character.inventory_objects.item.map { |item| item.subject.item_type.key }
    end

    def build_recipe?
      recipe.recipe_type == Recipe::BUILD
    end

    def recipe
      @recipe ||= @project.recipe
    end
  end
end
