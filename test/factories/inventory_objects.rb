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
FactoryBot.define do
  factory :inventory_object do
    subject_id { 1 }
    subject_type { 'Resource' }
    amount { 100 }
    unit { 'grams' }
    character
  end
end
