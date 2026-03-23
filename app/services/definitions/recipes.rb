# frozen_string_literal: true

module Definitions::Recipes
  RECIPES = [
    {
      key: 'stone_knife',
      base_speed: 3600,
      instructions: [
        { type: 'resource', key: 'stone', amount: 100 }
      ]
    },
    {
      key: 'wooden_shaft',
      base_speed: 3600,
      instructions: [
        { type: 'resource', key: 'wood', amount: 80 },
        { type: 'tool', key: 'stone_knife' }
      ]
    }
  ].freeze
end
