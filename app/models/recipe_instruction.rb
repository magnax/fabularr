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

  scope :item, -> { where(instruction_type: ITEM) }
  scope :machinery, -> { where(instruction_type: MACHINERY) }
  scope :placement, -> { where(instruction_type: PLACEMENT) }
  scope :resource, -> { where(instruction_type: RESOURCE) }
  scope :resource_out, -> { where(instruction_type: RESOURCE_OUT) }
  scope :tool, -> { where(instruction_type: TOOL) }

  # Types:
  ITEM = 'item'
  MACHINERY = 'machinery'
  MAX_AMOUNT = 'max_amount'
  PLACEMENT = 'placement'
  RESOURCE = 'resource'
  RESOURCE_OUT = 'resource_out'
  TOOL = 'tool'

  # Placements:
  OUTSIDE_ALL = 'outside_all'
end
