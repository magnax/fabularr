# frozen_string_literal: true

module Projects
  class OptionalTools < ApplicationService
    def initialize(project)
      @project = project
    end

    def call
      return {} if recipe.blank? || recipe.recipe_type != Recipe::COLLECT
      return {} if recipe.recipe_instructions.none?

      recipe.recipe_instructions.tool.reduce({}) { |acc, t| acc.merge({ t.subject.key => t.speed }) }
    end

    private

    def recipe
      @recipe ||= @project.recipe
    end
  end
end
