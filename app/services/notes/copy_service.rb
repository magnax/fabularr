# frozen_string_literal: true

module Notes
  class CopyService < ApplicationService
    def initialize(character, note_id)
      @character = character
      @note_id = note_id
    end

    def call
      raise Notes::InvalidNoteError unless valid_note?

      cloned_note = Note.create!(character: @character, **note_attrs)

      @character.inventory_objects.create(subject: cloned_note)
      create_events!
    end

    private

    def valid_note?
      note.present?
    end

    def note_attrs
      note.attributes.except('id', 'character_id', 'created_at', 'updated_at')
    end

    def create_events!
      body = I18n.t('events.notes.copy', note: note.title)
      Events::CreateAndBroadcastService.call(@character, body)

      create_location_events! if location.present?
    end

    def create_location_events!
      body = I18n.t('events.notes.copy_other', character_link: @character.char_id,
                                               note: note.title)
      Events::CreateEventForAllService.call(visible_characters, body,
                                            except: @character)
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

    def visible_characters
      @visible_characters ||= location.visible_characters
    end

    def location
      @location ||= @character.location
    end
  end
end
