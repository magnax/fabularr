# frozen_string_literal: true

module CharNames
  class UpsertService < ApplicationService
    class InvalidCharacterError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidCharacterError if named_char.blank?

      charname.update!(name_params)
    end

    private

    def name_params
      @params.tap do |param|
        param[:name] = named_char.default_name if param[:name].blank?
      end
    end

    def charname
      @character.char_names.where(named_id: named_char.id).first_or_create
    end

    def named_char
      @named_char ||= Character.find_by(id: @params[:named_id])
    end
  end
end
