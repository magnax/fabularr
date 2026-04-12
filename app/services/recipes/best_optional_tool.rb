# frozen_string_literal: true

module Recipes
  class BestOptionalTool < ApplicationService
    def initialize(character, recipe)
      @character = character
      @recipe = recipe
    end

    def call
      return unless character_tools.any?

      recipe_tools.each do |tool|
        return tool[:key] if tool[:key].in?(character_tools)
      end
    end

    private

    def character_tools
      @character_tools ||= @character.tools_keys
    end

    def recipe_tools
      @recipe_tools ||= Recipes::FetchOptionalTools.call(@recipe)
    end
  end
end
