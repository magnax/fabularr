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
        char.as_json(only: %i[id gender], methods: :project_info)
            .merge(
              name: char.name_for(char),
              male: char.male?,
              travel_info: travel_info(char),
              location_name: char.location&.display_name(char, parent: true),
              location_type: location_type(char)
            )
            .with_indifferent_access
      end
    end

    def location_type(char)
      return if char.location.blank?

      I18n.t("locations.#{char.toplevel_location.location_type.key}")
    end

    def travel_info(character)
      return unless character.travelling?

      {
        start_location_name: character.traveller.start_location.display_name(
          character.traveller.subject, parent: true
        ),
        end_location_name: end_location_name(character.traveller),
        speed: character.traveller.speed,
        direction: Maps.direction_text(character.traveller.direction),
        progress: progress(character.traveller)&.round(0)
      }
    end

    def end_location_name(traveller)
      return if traveller.road.blank?

      traveller.destination_location.display_name(traveller.subject, parent: true)
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
