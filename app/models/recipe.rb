# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipe_instructions, dependent: :destroy
end
