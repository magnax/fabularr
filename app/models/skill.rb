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
  # levels:
  AWKWARDLY = 'awkwardly'
  NOVICELY = 'novicely'
  EFFICIENTLY = 'efficiently'
  SKILLFULLY = 'skillfully'
  EXPERTLY = 'expertly'

  # skills
  ANIMAL_HUSBANDRY = 'animal_husbandry'
  BUILDING = 'building'
  BURYING = 'burying'
  CARPENTRY = 'carpentry'
  COLLECTING = 'collecting'
  COOKING = 'cooking'
  DIGGING = 'digging'
  DRILLING = 'drilling'
  FARMING = 'farming'
  FIGHTING = 'fighting'
  FISHING = 'fishing'
  FORESTRY = 'forestry'
  GARDENING = 'gardening'
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
    TAILORING
    WALKING
  ].freeze

  MAP_LEVELS = {
    0 => AWKWARDLY,
    1 => NOVICELY,
    2 => EFFICIENTLY,
    3 => SKILLFULLY,
    4 => EXPERTLY
  }.freeze
end
