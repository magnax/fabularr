# frozen_string_literal: true

module Characters
  module CreateService
    def self.call!(user, params)
      raise Users::TooManyCharactersError unless user.can_create_character?

      user.characters.create!(
        params.merge(
          location_id: random_location_id,
          spawn_location_id: random_location_id
        )
      )
    end

    def self.random_location_id
      @random_location_id ||= Location.random.first.id
    end
  end
end
