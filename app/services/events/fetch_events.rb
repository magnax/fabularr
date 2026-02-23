# frozen_string_literal: true

module Events
  module FetchEvents
    def self.call!(character)
      character.location.events.visible_for(character.id).map do |event|
        Events::ParseService.call(event, character)
      end
    end
  end
end
