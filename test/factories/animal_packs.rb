# frozen_string_literal: true

# == Schema Information
#
# Table name: animal_packs
#
#  id          :bigint           not null, primary key
#  amount      :integer
#  points      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  animal_id   :bigint
#  location_id :bigint
#
# Indexes
#
#  index_animal_packs_on_animal_id    (animal_id)
#  index_animal_packs_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_id => animals.id)
#  fk_rails_...  (location_id => locations.id)
#
FactoryBot.define do
  factory :animal_pack do
    animal
    location
    amount { 4 }
    points { 400 }
  end
end
