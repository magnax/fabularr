# frozen_string_literal: true

class LocationObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
end
