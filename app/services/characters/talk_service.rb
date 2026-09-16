# frozen_string_literal: true

module Characters
  class TalkService < ApplicationService
    def initialize(character, named_character_id)
      @character = character
      @named_character_id = named_character_id
    end

    def call
      raise InvalidCharacterError if named_character.blank?

      {
        charname: charname.name,
        named_character_id: @named_character_id
      }
    end

    private

    def charname
      @charname ||= @character.char_name_or_build(named_character)
    end

    def named_character
      @named_character ||= Character.find_by(id: @named_character_id)
    end
  end
end
