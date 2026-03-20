# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  base_speed :integer
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Recipe < ApplicationRecord
  has_many :recipe_instructions, dependent: :destroy
end
