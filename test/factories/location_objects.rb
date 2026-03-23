# frozen_string_literal: true

# == Schema Information
#
# Table name: location_objects
#
#  id           :bigint           not null, primary key
#  amount       :float
#  damage       :float            default(0.0)
#  subject_type :string
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :bigint
#  subject_id   :integer
#
# Indexes
#
#  index_location_objects_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
FactoryBot.define do
  factory :location_object do
    amount { 100 }
    unit { 'grams' }
    damage { 1.5 }
    location
  end
end
