# frozen_string_literal: true

class InventoryObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
end
