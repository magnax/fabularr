# frozen_string_literal: true

module Characters
  class ShowService < ApplicationService
    class InvalidCharacterError < StandardError; end

    def initialize(character, char_id)
      @character = character
      @char_id = char_id
    end

    def call
      raise InvalidCharacterError if subject_character.blank?

      {
        name: @character.name_for(subject_character)
      }.with_indifferent_access
    end

    private

    def subject_character
      @subject_character ||= Character.find_by(id: @char_id)
    end
  end
end
