# frozen_string_literal: true

module Projects
  class YieldPartialAmountService < ApplicationService
    def initialize(project, elapsed_time)
      @project = project
      @elapsed_time = elapsed_time
    end

    def call
      @project.update!(elapsed: new_elapsed_time)
      receiving_character.inventory_objects.create!(
        subject: resource, amount: @project.amount
      )
      if repeat_description.amount == 1
        repeat_description.destroy!
      else
        repeat_description.update!(amount: repeat_description.amount - 1)
      end
    end

    private

    def new_elapsed_time
      @elapsed_time - @project.duration
    end

    def receiving_character
      @receiving_character ||= @project.starting_character
    end

    def resource
      @resource ||= @project.project_descriptions.resource_out.first.subject
    end

    def repeat_description
      @repeat_description ||= @project.project_descriptions.repeat.first
    end
  end
end
