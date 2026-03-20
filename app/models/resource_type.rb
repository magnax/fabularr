# frozen_string_literal: true

# == Schema Information
#
# Table name: resource_types
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ResourceType < ApplicationRecord
  FOOD = 'food'
  FUEL = 'fuel'
  MATERIAL = 'material'
  MEDICINE = 'medicine'
  RAW_FOOD = 'raw_food'
end
