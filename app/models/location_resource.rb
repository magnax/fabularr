# frozen_string_literal: true

class LocationResource < ApplicationRecord
  belongs_to :location, optional: true
end
