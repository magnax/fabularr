# frozen_string_literal: true

class Event < ApplicationRecord
  NEWEST_COUNT = 20

  belongs_to :location
  belongs_to :character

  scope :newest, -> { order(created_at: :desc).last(NEWEST_COUNT) }
end
