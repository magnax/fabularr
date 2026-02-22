# frozen_string_literal: true

module Events
  module FetchEvents
    def self.call!(character)
      character.location.events.visible_for(character.id).map { |e| e.parse(character) }
    end
  end
end
