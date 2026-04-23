# frozen_string_literal: true

module Users
  class ShowService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      {
        user: @user,
        characters: characters
      }
    end

    private

    def characters
      @characters ||= @user.characters
                           .includes(
                             location: %i[location_type parent_location]
                           )
    end
  end
end
