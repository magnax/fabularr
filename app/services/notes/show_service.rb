# frozen_string_literal: true

module Notes
  class ShowService < ApplicationService
    def initialize(character, note_id)
      @character = character
      @note_id = note_id
    end

    def call
      raise Notes::InvalidNoteError if note.blank?

      {
        note: {
          id: note.id,
          title: note.title,
          body: note.body,
          editable: editable?
        }
      }
    end

    private

    def editable?
      note.editable && location_note.blank?
    end

    def note
      @note ||=
        @character.inventory_objects.note.find_by(subject_id: @note_id)&.subject ||
        location_note
    end

    def location_note
      @location_note ||= location.present? &&
                         location.location_objects.find_by(subject_id: @note_id)&.subject
    end

    def location
      @location ||= @character.location
    end
  end
end
