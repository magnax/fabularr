# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Skill < ApplicationRecord
  has_many :recipes, dependent: :destroy

  # levels:
  AWKWARDLY = 'awkwardly'
  NOVICELY = 'novicely'
  EFFICIENTLY = 'efficiently'
  SKILLFULLY = 'skillfully'
  EXPERTLY = 'expertly'

  # strength levels
  AVERAGE_STRENGTH = 'average_strength'
  STRONGER = 'stronger'
  WEAKER = 'weaker'
  VERY_WEAK = 'very_weak'
  VERY_STRONG = 'very_strong'

  # skills
  ANIMAL_HUSBANDRY = 'animal_husbandry'
  BUILDING = 'building'
  BURYING = 'burying'
  CARPENTRY = 'carpentry'
  COLLECTING = 'collecting'
  COOKING = 'cooking'
  DIGGING = 'digging'
  DRILLING = 'drilling'
  EXPLORING = 'exploring'
  FARMING = 'farming'
  FIGHTING = 'fighting'
  FISHING = 'fishing'
  FORESTRY = 'forestry'
  GARDENING = 'gardening'
  GATHERING = 'gathering'
  HUNTING = 'hunting'
  MANUFACTURING = 'manufacturing'
  MANUFACTURING_MACHINES = 'manufacturing_machines'
  MANUFACTURING_TOOLS = 'manufacturing_tools'
  MANUFACTURING_VEHICLES = 'manufacturing_vehicles'
  MANUFACTURING_WEAPONS = 'manufacturing_weapons'
  MINING = 'mining'
  REFINING = 'refining'
  SHIPBUILDING = 'shipbuilding'
  SMELTING = 'smelting'
  STRENGTH = 'strength'
  TAILORING = 'tailoring'
  WALKING = 'walking'

  SKILLS = %w[
    ANIMAL_HUSBANDRY
    BUILDING
    BURYING
    CARPENTRY
    COLLECTING
    COOKING
    DIGGING
    DRILLING
    FARMING
    FIGHTING
    FISHING
    FORESTRY
    GARDENING
    GATHERING
    HUNTING
    MANUFACTURING
    MANUFACTURING_MACHINES
    MANUFACTURING_TOOLS
    MANUFACTURING_VEHICLES
    MANUFACTURING_WEAPONS
    MINING
    REFINING
    SHIPBUILDING
    SMELTING
    STRENGTH
    TAILORING
    WALKING
  ].freeze

  COLLECTING_SKILLS = %w[
    COLLECTING
    DIGGING
    DRILLING
    FARMING
    FISHING
    FORESTRY
    GARDENING
    GATHERING
    MINING
  ].freeze

  MAP_LEVELS = {
    0 => AWKWARDLY,
    1 => NOVICELY,
    2 => EFFICIENTLY,
    3 => SKILLFULLY,
    4 => EXPERTLY
  }.freeze

  MAP_STRENGTH = {
    0 => VERY_WEAK,
    1 => WEAKER,
    2 => AVERAGE_STRENGTH,
    3 => STRONGER,
    4 => VERY_STRONG
  }.freeze

  DAYS_PER_LEVEL = {
    0 => 127.521,
    1 => 141.69,
    2 => 157.434,
    3 => 174.927
  }.freeze
end
