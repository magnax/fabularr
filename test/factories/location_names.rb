# frozen_string_literal: true

# == Schema Information
#
# Table name: location_names
#
#  id           :bigint           not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :bigint
#  location_id  :bigint
#
# Indexes
#
#  index_location_names_on_character_id  (character_id)
#  index_location_names_on_location_id   (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (character_id => characters.id)
#  fk_rails_...  (location_id => locations.id)
#
FactoryBot.define do
  factory :loation_name do
    character
    location
    name { 'Town Hall ' }
  end
end
