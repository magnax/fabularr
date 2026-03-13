# frozen_string_literal: true

class RecipeInstruction < ApplicationRecord
  belongs_to :recipe
  belongs_to :subject, polymorphic: true, optional: true

  scope :resource, -> { where(instruction_type: RESOURCE) }

  # Types:
  RESOURCE = 'resource'
end
