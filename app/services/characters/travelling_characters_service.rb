module Characters
  class TravellingCharactersService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      return [] unless @character.travelling?

      Character
        .where(id: Traveller.character.pluck(:subject_id) - [@character.id])
        .where(
          "length(
            lseg(coords::point, point(#{@character.x},#{@character.y}))
          ) <= ? ", Character::MIN_HEARABLE_DISTANCE
        )
    end
  end
end
