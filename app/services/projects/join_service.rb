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

      Worker.create!(project: project, character: @character,
                     speed: speed)
    end

    private

    def can_join?
      Recipes::CheckToolRequirementsService.call(@character, project)
    end

    def speed
      return 1 unless speed_change?

      best_tool_instruction.speed
    end

    def speed_change?
      return false unless project.project_type.key == 'collect'
      return false unless project.recipe

      best_tool_instruction.present?
    end

    def best_tool_instruction
      @best_tool_instruction ||=
        instructions.each do |instruction|
          key = instruction.subject.key
          return instruction if key.in? character_tool_keys
        end
    end

    def instructions
      @instructions ||= project.recipe
                               .recipe_instructions
                               .tool
                               .order(speed: :desc)
    end

    def character_tool_keys
      @character_tool_keys ||=
        @character.inventory_objects.item.map do |tool|
          tool.subject.item_type.key
        end
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
