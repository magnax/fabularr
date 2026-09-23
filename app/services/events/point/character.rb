# frozen_string_literal: true

module Events
  class Point::Character < ApplicationService
    def initialize(character, subject)
      @character = character
      @subject = subject
    end

    def call
      raise InvalidPointObjectError unless visible_character?

      Event.create!(
        body: I18n.t('events.point.point_person_me', char_name: @subject.char_id),
        receiver_character_id: @character.id
      )

      create_subject_event!
      create_location_events!
    end

    private

    def visible_character?
      @subject.visible_by?(@character)
    end

    def create_location_events!
      Events::CreateEventForAllService.call(@character.location.visible_characters,
                                            body, except: [@character, @subject])
    end

    def body
      I18n.t(
        'events.point.point_person_other',
        char_name_1: @character.char_id,
        char_name_2: @subject.char_id
      )
    end

    def create_subject_event!
      Events::CreateAndBroadcastService.call(
        @subject, I18n.t('events.point.point_person_you', char_name: @character.char_id)
      )
    end
  end
end
