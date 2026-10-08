# frozen_string_literal: true

module Notes
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    # TODO: body & title have to be sanitized!
    def call
      note = Note.create!(character: @character, **@params)
      @character.inventory_objects.create(subject: note)
    end
  end
end
