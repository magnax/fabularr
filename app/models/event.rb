# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  body                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  character_id          :integer
#  location_id           :integer
#  receiver_character_id :integer
#
class Event < ApplicationRecord
  NEWEST_COUNT = 20
  CHARID_REGEX = /<!--CHARID:(\d+)-->/

  belongs_to :location
  belongs_to :character, optional: true
  belongs_to :receiver_character, class_name: 'Character', optional: true

  scope :visible_for, lambda { |character_id|
    where(receiver_character_id: [nil, character_id]).or(Event.where(character_id: character_id)).newest
  }
  scope :newest, -> { order(created_at: :desc).first(NEWEST_COUNT) }
end
