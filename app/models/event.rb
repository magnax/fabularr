# frozen_string_literal: true

class Event < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  NEWEST_COUNT = 20
  CHARID_REGEX = /<!--CHARID:(\d+)-->/

  belongs_to :location
  belongs_to :character, optional: true

  scope :visible_for, ->(character) { where(receiver_character_id: [nil, character]).newest }
  scope :newest, -> { order(created_at: :desc).last(NEWEST_COUNT) }

  def parse(character)
    {
      body: parsed_body(character),
      character: character.name_for(self.character),
      created_at: created_at.strftime('%Y-%m-%d')
    }.with_indifferent_access
  end

  def parsed_body(character)
    parsed_body = body
    char_match = parsed_body.match(CHARID_REGEX)
    return parsed_body unless char_match

    character_for = Character.find_by(id: char_match[1])
    name_for = link_to character.name_for(character_for), character_name_url(character_for.id, only_path: true)
    parsed_body.gsub(CHARID_REGEX, name_for)
  end
end
