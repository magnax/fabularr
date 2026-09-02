# frozen_string_literal: true

module Characters
  class DeathService < ApplicationService
    def initialize(character_id)
      @character_id = character_id
    end

    def call
      character.update!(status: false, weight: Character::WEIGHT)
    end

    private

    def character
      @character ||= Character.find_by(id: @character_id)
    end
  end
end
