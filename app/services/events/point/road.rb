# frozen_string_literal: true

module Events
  class Point::Road < ApplicationService
    def initialize(character, subject)
      @character = character
      @subject = subject
    end

    def call
      raise InvalidPointObjectError unless visible_road?

      Event.create!(
        body: I18n.t('events.point.point_road_me', road_info: road_info),
        receiver_character_id: @character.id
      )

      create_location_events!
    end

    private

    def visible_road?
      true
    end

    def create_location_events!
      @character.location.visible_characters.each do |char|
        next if @character == char

        event = Event.create!(
          body: I18n.t(
            'events.point.point_road_other',
            road_info: road_info,
            character_link: @character.char_id
          ),
          receiver_character: char
        )

        Events::BroadcastService.call(char.id, event.id)
      end
    end

    def road_info
      I18n.t('roads.name',
             type: I18n.t("roads.types.#{road.road_type}"),
             location_link: road.destination_location(@character.location).loc_id)
    end

    def road
      @road ||= @subject
    end
  end
end
