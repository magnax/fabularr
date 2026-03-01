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
      parsed_body = @event.body
      char_match = parsed_body.match(Event::CHARID_REGEX)
      return parsed_body unless char_match

      character_for = Character.find_by(id: char_match[1])
      name_for = link_to_name_for(character_for)
      parsed_body.gsub(Event::CHARID_REGEX, name_for)
    end

    def parsed_lead
      l = lead
      I18n.t(l[:key], char_name: l[:char_name])
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
        character_name_url(char.id, only_path: true)
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
