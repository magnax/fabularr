# frozen_string_literal: true

# == Schema Information
#
# Table name: location_classes
#
#  id         :bigint           not null, primary key
#  key        :string
#  moveable   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LocationClass < ApplicationRecord
  ANIMAL = 'animal'
  BUILDING = 'building'
  SHIP = 'ship'
  TOWN = 'town'
  VEHICLE = 'vehicle'
end
