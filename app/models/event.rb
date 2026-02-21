# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :location
  belongs_to :character
end
