# frozen_string_literal: true

class LocationObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :location

  scope :resource, -> { where(subject_type: 'Resource') }
end
