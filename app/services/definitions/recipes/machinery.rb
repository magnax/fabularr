# frozen_string_literal: true

module Definitions::Recipes::Machinery
  RECIPES = [
    {
      key: 'dried_dung#drying',
      machine: 'small_fire_pit',
      skill: 'cooking',
      instructions: [
        { key: 'resource#fresh_dung', amount: 1000 },
        { key: 'resource_out#dried_dung', amount: 800 }
      ]
    }
  ].freeze
end
