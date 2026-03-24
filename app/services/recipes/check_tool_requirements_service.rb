# frozen_string_literal: true

module Recipes
  class CheckToolRequirementsService < ApplicationService
    def initialize(character, project)
      @character = character
      @project = project
    end

    def call
      return true if @project.recipe.blank? || tools_needed.none?

      tools_needed.all? { |tool| tool.subject.key.in?(items_keys) }
    end

    private

    def tools_needed
      @tools_needed ||= @project.recipe.recipe_instructions.tool
    end

    def items_keys
      @character.inventory_objects.item.map { |item| item.subject.item_type.key }
    end
  end
end
