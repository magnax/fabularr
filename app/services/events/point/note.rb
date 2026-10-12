# frozen_string_literal: true

module Events
  class Point::Note < ApplicationService
    def initialize(character, subject)
      @character = character
      @subject = subject
    end

    def call
      raise InvalidPointObjectError if note.blank?

      Event.create!(
        body: I18n.t(key_body_me, note: note.title),
        receiver_character_id: @character.id
      )

      create_location_events!
    end

    private

    def create_location_events!
      Events::CreateEventForAllService.call(@character.location.visible_characters,
                                            body, except: @character)
    end

    def body
      I18n.t(
        key_body_other,
        note: note.title,
        character_link: @character.char_id
      )
    end

    def key_body_me
      return 'events.point.point_note_me' if location_note

      # TODO: Add character's gender
      'events.point.point_inventory_note_me'
    end

    def key_body_other
      return 'events.point.point_note_other' if location_note

      # TODO: Add character's gender
      'events.point.point_inventory_note_other'
    end

    def note
      @note ||= location_note || inventory_note
    end

    def location_note
      location.present? &&
        location.location_objects.note.find_by(subject_id: @subject.id)&.subject
    end

    def inventory_note
      @character.inventory_objects.note.find_by(subject_id: @subject.id)&.subject
    end

    def location
      @location ||= @character.location
    end
  end
end
