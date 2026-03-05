# frozen_string_literal: true

module Events
  class FetchEvents < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      events.map do |event|
        Events::ParseService.call(event, @character)
      end
    end

    private

    def events
      @events ||= location.events
                          .includes(:character, :receiver_character)
                          .where('created_at > ?', @character.created_at)
                          .visible_for(@character.id)
    end

    def location
      @location ||= @character.location
    end
  end
end
