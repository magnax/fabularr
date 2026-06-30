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
    },
    {
      key: 'grilled_meat_dung#grilling',
      machine: 'small_fire_pit',
      skill: 'cooking',
      instructions: [
        { key: 'resource#meat', amount: 250 },
        { key: 'resource#dried_dung', amount: 200 },
        { key: 'resource_out#grilled_meat', amount: 225 }
      ]
    },
    {
      key: 'grilled_meat_firewood#grilling',
      machine: 'small_fire_pit',
      skill: 'cooking',
      instructions: [
        { key: 'resource#meat', amount: 250 },
        { key: 'resource#firewood', amount: 150 },
        { key: 'resource_out#grilled_meat', amount: 225 }
      ]
    }
  ].freeze
end
