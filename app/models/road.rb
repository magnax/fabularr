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
class Road < ApplicationRecord
  belongs_to :location_1, class_name: 'Location'
  belongs_to :location_2, class_name: 'Location'

  PATH = 'path'
end
