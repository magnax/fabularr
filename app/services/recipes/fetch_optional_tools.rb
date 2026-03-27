# frozen_string_literal: true

module Recipes
  class FetchOptionalTools < ApplicationService
    def initialize(recipe)
      @recipe = recipe
    end

    def call
      tools_with_speed.map { |tool| { key: tool.key, speed: tool.speed } }
    end

    private

    def tools_with_speed
      @tools_with_speed ||=
        tools.joins('left join item_types it on it.id = subject_id')
             .order(speed: :desc)
             .select(:speed, 'it.key')
    end

    def tools
      @tools ||= @recipe.recipe_instructions.tool
    end
  end
end
