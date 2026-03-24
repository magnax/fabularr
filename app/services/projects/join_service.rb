# frozen_string_literal: true

module Projects
  class JoinService < ApplicationService
    class ProjectNotFoundError < StandardError; end

    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      raise ProjectNotFoundError if project.blank?
      return unless can_join?

      Worker.create!(project: project, character: @character)
    end

    private

    def can_join?
      return true if recipe.blank? || recipe.recipe_instructions.tool.none?

      needed_tools.all? do |tool|
        tool.subject.key.in? inventory_keys
      end
    end

    def needed_tools
      @needed_tools ||= recipe.recipe_instructions.tool
    end

    def inventory_keys
      @inventory_keys ||= @character.inventory_objects
                                    .item
                                    .map { |item| item.subject.item_type.key }
    end

    def recipe
      @recipe ||= project.recipe
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
