# frozen_string_literal: true

module Projects
  class ShowService < ApplicationService
    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      {}
    end
  end
end
