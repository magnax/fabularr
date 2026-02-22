# frozen_string_literal: true

module Characters
  module CreateInitialEvents
    def self.call!(character)
      location = character.location
      location.events.create!(
        character_id: nil,
        receiver_character_id: character.id,
        body: I18n.t('events.initial.location_info')
      )
      location.events.create!(
        character_id: nil,
        receiver_character_id: character.id,
        body: I18n.t('events.initial.people_info')
      )
      location.characters.each do |ch|
        next if ch == character

        location.events.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: I18n.t('events.people.spawn_info', character_link: "<!--CHARID:#{character.id}-->")
        )
      end
    end
  end
end
