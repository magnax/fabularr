# frozen_string_literal: true

# == Schema Information
#
# Table name: recipe_instructions
#
#  id               :bigint           not null, primary key
#  amount           :integer
#  instruction_type :string
#  metadata         :jsonb
#  speed            :float
#  subject_type     :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipe_id        :bigint
#  subject_id       :integer
#
# Indexes
#
#  index_recipe_instructions_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
class RecipeInstruction < ApplicationRecord
  belongs_to :recipe
  belongs_to :subject, polymorphic: true, optional: true

  scope :machinery, -> { where(instruction_type: MACHINERY) }
  scope :resource, -> { where(instruction_type: RESOURCE) }
  scope :tool, -> { where(instruction_type: TOOL) }
  scope :placement, -> { where(instruction_type: PLACEMENT) }

  # Types:
  MACHINERY = 'machinery'
  RESOURCE = 'resource'
  TOOL = 'tool'
  PLACEMENT = 'placement'

  # Placements:
  OUTSIDE_ALL = 'outside_all'
end
