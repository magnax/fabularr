# frozen_string_literal: true

module Events
  class ParseService < ApplicationService
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def initialize(event, viewing_character, parsed: false)
      @event = event
      @viewing_character = viewing_character
      @parsed = parsed
    end

    def call
      {
        body: parsed_body,
        lead: @parsed ? parsed_lead : lead,
        created_at: parsed_time
      }.with_indifferent_access
    end

    private

    def parsed_body
      event_body = @event.body || ''
      event_body = parse_characters(event_body)
      parse_locations(event_body)
    end

    def parse_characters(event_body)
      char_matches = event_body.scan(Event::CHARID_REGEX)
      return event_body unless char_matches.any?

      char_matches.flatten.each do |match|
        character_for = Character.find_by(id: match)
        name_for = link_to_name_for(character_for)
        event_body = event_body.gsub(Event::CHARID_REGEX_TEXT.gsub('(\d+)', match), name_for)
      end
      event_body
    end

    def parse_locations(event_body)
      location_matches = event_body.scan(Event::LOCID_REGEX)
      return event_body unless location_matches.any?

      location_matches.flatten.each do |match|
        location_for = Location.find_by(id: match)
        name_for = link_to_location_name_for(location_for)

        event_body = event_body.gsub(Event::LOCID_REGEX_TEXT.gsub('(\d+)', match), name_for)
      end

      event_body
    end

    def parsed_lead
      l = lead

      I18n.t(l[:key], char_name: l[:char_name]) if l
    end

    def lead
      return if @event.character_id.blank?

      if @event.character_id == @viewing_character.id
        if @event.receiver_character_id.present?
          {
            key: 'events.character.talking.to_other',
            char_name: link_to_name_for(@event.receiver_character)
          }
        else
          {
            key: 'events.character.talking.me',
            char_name: nil
          }
        end
      elsif @event.receiver_character_id == @viewing_character.id
        {
          key: 'events.character.talking.to_me',
          char_name: link_to_name_for(character)
        }
      else
        {
          key: 'events.character.talking.other',
          char_name: link_to_name_for(character)
        }
      end
    end

    def link_to_name_for(char)
      return if char.blank?

      link_to(
        @viewing_character.name_for(char),
        character_name_url(character_id: char.id, only_path: true)
      )
    end

    def link_to_location_name_for(location)
      return if location.blank?

      link_to(
        location.display_name(@viewing_character),
        location_name_url(location_id: location.id, only_path: true)
      )
    end

    def parsed_time
      @event.created_at.strftime('%Y-%m-%d')
    end

    def character
      @event.character
    end
  end
end
