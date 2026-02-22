# frozen_string_literal: true

module Characters
  module CreateInitialEvents
    def self.call!(character)
      character.events.create!(location: character.location, body: I18n.t('events.initial.location_info'))
      character.events.create!(location: character.location, body: I18n.t('events.initial.people_info'))
    end
  end
end
