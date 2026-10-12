# frozen_string_literal: true

module Notes
  class CreateService < ApplicationService
    include Notes::SanitizeInputHelper

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      note = Note.create!(character: @character, **sanitized_params)
      @character.inventory_objects.create(subject: note)
    end

    private

    def sanitized_params
      {
        title: sanitize_title(@params[:title]),
        body: sanitize_body(@params[:body])
      }
    end
  end
end
