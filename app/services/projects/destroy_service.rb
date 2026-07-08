# frozen_string_literal: true

module Projects
  class DestroyService < ApplicationService
    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      raise Projects::NotOwnerError unless owner?

      release_resources!

      project.destroy!
    end

    private

    def owner?
      @character == project.starting_character
    end

    def release_resources!
      project.project_descriptions.resource_in.each do |description|
        unless description.amount.zero?
          InventoryObjects::IncreaseAmountService.call(
            @character, description.subject.key, description.amount
          )
        end
        description.destroy!
      end
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
