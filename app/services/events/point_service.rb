# frozen_string_literal: true

module Events
  class PointService < ApplicationService
    def initialize(character, subject_type, subject_id)
      @character = character
      @subject_type = subject_type
      @subject_id = subject_id
    end

    def call
      Event.create!(
        body: I18n.t('events.point.point_person_me', char_name: subject.char_id),
        receiver_character_id: @character.id
      )

      create_subject_event!
      create_location_events!
    end

    private

    def create_location_events!
      @character.location.visible_characters.each do |char|
        next if char == @character || char == subject

        event = Event.create!(
          body: I18n.t(
            'events.point.point_person_other',
            char_name_1: @character.char_id,
            char_name_2: subject.char_id
          ),
          receiver_character: char
        )

        Events::BroadcastService.call(char.id, event.id)
      end
    end

    def create_subject_event!
      event = Event.create!(
        body: I18n.t('events.point.point_person_you', char_name: @character.char_id),
        receiver_character_id: subject.id
      )

      Events::BroadcastService.call(subject.id, event.id)
    end

    def subject
      @subject_type.camelize.constantize.find_by(id: @subject_id)
    end
  end
end
