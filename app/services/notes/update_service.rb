# frozen_string_literal: true

module Notes
  class UpdateService < ApplicationService
    include Notes::SanitizeInputHelper

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise Notes::InvalidNoteError if note.blank? || !note.editable

      note.update!(**update_attrs)
    end

    private

    def update_attrs
      {
        title: sanitize_title(@params[:title]),
        body: sanitize_body(@params[:body])
      }
    end

    def note
      @note ||= @character.inventory_objects.note
                          .find_by(subject_id: @params[:id])&.subject
    end
  end
end
