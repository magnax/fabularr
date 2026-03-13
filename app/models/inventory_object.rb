# frozen_string_literal: true

class InventoryObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :character

  scope :resource, -> { where(subject_type: 'Resource') }
end
