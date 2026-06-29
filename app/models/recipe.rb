# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  base_speed  :integer
#  key         :string
#  recipe_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint
#
# Indexes
#
#  index_recipes_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#
class Recipe < ApplicationRecord
  has_many :recipe_instructions, dependent: :destroy
  belongs_to :skill, optional: true

  BUILDING = 'building'
  COLLECT = 'collect'
  ITEM = 'item'
  MACHINERY = 'machinery'
  VEHICLE = 'vehicle'

  BUILD_TYPES = [ITEM, BUILDING, MACHINERY, VEHICLE].freeze

  scope :by_type, ->(type) { where(recipe_type: type) }
end
