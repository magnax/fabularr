# frozen_string_literal: true

module Notes
  class ShowService < ApplicationService
    def initialize(character, note_id)
      @character = character
      @note_id = note_id
    end

    def call
      {
        note: {
          id: note.id,
          title: note.title,
          body: note.body
        }
      }
    end

    private

    def note
      @note ||= Note.find_by(id: @note_id)
    end
  end
end
