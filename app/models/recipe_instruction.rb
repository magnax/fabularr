# frozen_string_literal: true

class RecipeInstruction < ApplicationRecord
  belongs_to :recipe
  belongs_to :subject, polymorphic: true, optional: true
end
