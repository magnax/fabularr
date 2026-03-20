# frozen_string_literal: true

# == Schema Information
#
# Table name: inventory_objects
#
#  id           :bigint           not null, primary key
#  amount       :float
#  subject_type :string
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :bigint
#  subject_id   :integer
#
# Indexes
#
#  index_inventory_objects_on_character_id  (character_id)
#
# Foreign Keys
#
#  fk_rails_...  (character_id => characters.id)
#
class InventoryObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :character

  scope :resource, -> { where(subject_type: 'Resource') }
end
