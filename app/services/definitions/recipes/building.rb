# frozen_string_literal: true

module Definitions::Recipes::Building
  RECIPES = [
    {
      key: 'wood_shack#building',
      base_speed: 500,
      instructions: [
        { key: 'resource#wood', amount: 100 }
      ]
    },
    {
      key: 'lighthouse#building',
      base_speed: 500,
      placement: 'outside_all',
      instructions: [
        { key: 'resource#stone', amount: 20_000 },
        { key: 'resource#window_glass', amount: 200 },
        { key: 'resource#iron', amount: 300 },
        {
          key: 'tool#hammer',
          options: [
            { key: 'stone_hammer' },
            { key: 'steel_hammer' }
          ]
        },
        {
          key: 'tool#trowel',
          options: [
            { key: 'wooden_trowel' },
            { key: 'iron_trowel' }
          ]
        }
      ]
    }
  ].freeze
end
