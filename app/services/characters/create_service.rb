# frozen_string_literal: true

module Characters
  class CreateService < ApplicationService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      raise Users::TooManyCharactersError unless @user.can_create_character?

      new_char = @user.characters.create!(
        @params.merge(
          location_id: random_location_id,
          spawn_location_id: random_location_id
        )
      )

      Characters::CreateInitialEvents.call!(new_char)
    end

    private

    def random_location_id
      @random_location_id ||= Location.random.first.id
    end
  end
end
