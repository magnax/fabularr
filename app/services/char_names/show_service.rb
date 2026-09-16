# frozen_string_literal: true

module CharNames
  class ShowService < ApplicationService
    def initialize(character, named_character_id)
      @character = character
      @named_character_id = named_character_id
    end

    def call
      {
        charname: {
          name: charname.name,
          char_id: charname.named_id
        }
      }
    end

    private

    def charname
      @charname ||= @character.char_name_or_build(named_character)
    end

    def named_character
      @named_character ||= Character.find(@named_character_id)
    end
  end
end
