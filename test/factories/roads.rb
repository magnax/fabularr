# frozen_string_literal: true

# == Schema Information
#
# Table name: roads
#
#  id            :bigint           not null, primary key
#  road_type     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_1_id :bigint
#  location_2_id :bigint
#
# Indexes
#
#  index_roads_on_location_1_id  (location_1_id)
#  index_roads_on_location_2_id  (location_2_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_1_id => locations.id)
#  fk_rails_...  (location_2_id => locations.id)
#
FactoryBot.define do
  factory :road do
    road_type { Road::PATH }
    location_1 { FactoryBot.create(:location) }
    location_2 { FactoryBot.create(:location) }
  end
end
