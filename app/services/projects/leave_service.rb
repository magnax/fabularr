# frozen_string_literal: true

module Projects
  class LeaveService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      Workers::EndService.call(@character)
    end
  end
end
