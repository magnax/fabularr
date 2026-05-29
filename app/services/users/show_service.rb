# frozen_string_literal: true

module Users
  class ShowService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      {
        user: @user,
        characters: characters_info
      }
    end

    private

    def characters_info
      characters.map do |char|
        char.as_json(
          only: %i[id gender],
          methods: %i[damage_level hunger_level project_info]
        ).merge(
          location_name: char.location&.display_name(char, parent: true),
          location_type: location_type(char),
          male: char.male?,
          name: char.name_for(char),
          travel_info: travel_info(char),
          unread_events: char.visible_events.unread.length
        )
            .with_indifferent_access
      end
    end

    def location_type(char)
      return if char.location.blank?

      key = if char.location.town? || char.toplevel_location&.town?
              'locations'
            else
              char.location.location_class.key.pluralize
            end
      I18n.t("#{key}.#{char.toplevel_location.location_type.key}")
    end

    def travel_info(character)
      return unless character.travelling?

      traveller = character.traveller || character.location&.traveller

      {
        start_location_name: traveller.start_location.display_name(
          character, parent: true
        ),
        end_location_name: end_location_name(traveller, character),
        speed: traveller.speed,
        direction: Maps.direction_text(traveller.direction),
        progress: progress(traveller)&.round(0)
      }
    end

    def end_location_name(traveller, character)
      return if traveller.road.blank?

      traveller.destination_location.display_name(character, parent: true)
    end

    def progress(traveller)
      return if traveller.road.blank?

      Maps.calculate_percent(traveller, traveller.road)
    end

    def characters
      @characters ||= @user.characters
                           .includes(
                             location: %i[location_type location_class parent_location]
                           )
    end
  end
end
