# frozen_string_literal: true

class Worker < ApplicationRecord
  belongs_to :project
  belongs_to :character

  scope :active, -> { where(left_at: nil) }
end
