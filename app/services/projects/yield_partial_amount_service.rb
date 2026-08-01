# frozen_string_literal: true

module Projects
  class YieldPartialAmountService < ApplicationService
    def initialize(project, elapsed_time)
      @project = project
      @elapsed_time = elapsed_time
    end

    def call
      @project.update!(elapsed: new_elapsed_time)

      InventoryObjects::IncreaseAmountService.call(
        receiving_character, resource.key, resource_description.amount_needed
      )

      repeat_description.update!(amount: repeat_description.amount - 1)
      return unless repeat_description.amount == 1

      repeat_description.destroy!
    end

    private

    def new_elapsed_time
      @project.elapsed + @elapsed_time - @project.duration
    end

    def receiving_character
      @receiving_character ||= @project.starting_character
    end

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= @project.project_descriptions.resource_out.first
    end

    def repeat_description
      @repeat_description ||= @project.project_descriptions.repeat.first
    end
  end
end
