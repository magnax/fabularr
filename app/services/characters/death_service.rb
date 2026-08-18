# frozen_string_literal: true

module Characters
  class DeathService < ApplicationService
    def initialize(character_id)
      @character_id = character_id
    end

    def call
      true # TODO: dummy service for now
    end
  end
end
