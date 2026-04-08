# frozen_string_literal: true

module Travellers
  class StartService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
      @location = @character.location
    end

    def call
      @character.update!(coords: @location.coords, location: nil)
      Traveller.create!(subject: @character, direction: @params[:direction])

      create_event!
    end

    private

    def create_event!
      Event.create!(
        body: I18n.t('events.travel.start', location_link: @location.loc_id,
                                            direction: @params[:direction]),
        receiver_character: @character
      )
    end
  end
end
