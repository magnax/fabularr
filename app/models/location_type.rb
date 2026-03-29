# frozen_string_literal: true

# == Schema Information
#
# Table name: location_types
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LocationType < ApplicationRecord
  has_many :locations, dependent: nil

  BEACH = 'beach'
  DESERT = 'desert'
  FIELDS = 'fields'
  FOREST = 'forest'
  HILLS = 'hills'
  LAKESIDE = 'lakeside'
  MEADOW = 'meadow'
  MOUNTAINS = 'mountains'
  SWAMP = 'swamp'
  TUNDRA = 'tundra'

  COLOR_BEACH = 'ffeeaa'
  COLOR_DESERT = 'ffff00'
  COLOR_FIELDS = '66ff00'
  COLOR_FOREST = '008000'
  COLOR_HILLS = '37c8ab'
  COLOR_LAKESIDE = '87deaa'
  COLOR_MEADOW = '00ff66'
  COLOR_MOUNTAINS = 'b3b3b3'
  COLOR_SWAMP = 'ac939d'
  COLOR_TUNDRA = '808080'
  COLOR_WATER = '00ffff'
  COLOR_BORDER = 'e6e6e6'

  HABITABLE_TYPES_COLORS = [
    COLOR_BEACH, COLOR_DESERT, COLOR_FIELDS, COLOR_FOREST,
    COLOR_HILLS, COLOR_LAKESIDE, COLOR_MEADOW, COLOR_MOUNTAINS,
    COLOR_SWAMP, COLOR_TUNDRA
  ].freeze

  COLOR_MAP = {
    COLOR_BEACH => BEACH,
    COLOR_DESERT => DESERT,
    COLOR_FIELDS => FIELDS,
    COLOR_FOREST => FOREST,
    COLOR_HILLS => HILLS,
    COLOR_LAKESIDE => LAKESIDE,
    COLOR_MEADOW => MEADOW,
    COLOR_MOUNTAINS => MOUNTAINS,
    COLOR_SWAMP => SWAMP,
    COLOR_TUNDRA => TUNDRA
  }.freeze
end
