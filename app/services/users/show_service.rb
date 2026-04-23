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
              location_type: char.location&.location_type&.key
            )
            .with_indifferent_access
      end
    end

    def travel_info(character)
      return unless character.travelling?

      {
        location_id: character.traveller.start_location_id,
        location_name: character.traveller.start_location.display_name(character, parent: true),
        speed: character.traveller.speed,
        direction: character.traveller.direction
      }
    end

    def characters
      @characters ||= @user.characters
                           .includes(
                             location: %i[location_type location_class parent_location]
                           )
    end
  end
end
