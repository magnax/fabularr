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
  TOWN = 'town'
  BUILDING = 'building'
  VEHICLE = 'vehicle'
  ANIMAL = 'animal'
end
